import 'package:observatorio_geo_hist/app/core/models/article_model.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/browser/page_meta_data.dart';
import 'package:observatorio_geo_hist/app/core/utils/seo/route_meta.dart';
import 'package:observatorio_geo_hist/app/core/utils/strings/plain_text.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/team/sort_team.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';

import 'catalog_reader.dart';
import 'seo_exception.dart';

const int listingPageSize = 50;

enum PageKind { home, fixed, collection, post, document, member }

class PageLink {
  const PageLink(this.title, this.route);

  final String title;
  final String route;
}

class PageFact {
  const PageFact(this.label, this.value);

  final String label;
  final String value;
}

class SitePage {
  const SitePage({
    required this.kind,
    required this.meta,
    required this.heading,
    this.paragraphs = const [],
    this.links = const [],
    this.breadcrumbs = const [],
    this.facts = const [],
    this.previous,
    this.next,
    this.lastModified,
    this.schema = const {},
  });

  final PageKind kind;
  final PageMeta meta;
  final String heading;
  final List<String> paragraphs;
  final List<PageLink> links;
  final List<PageLink> breadcrumbs;
  final List<PageFact> facts;

  /// Routes of the neighbour pages of a paginated listing.
  final String? previous;
  final String? next;

  final DateTime? lastModified;

  /// Type-specific JSON-LD properties, merged over the common ones.
  final Map<String, dynamic> schema;

  String get route => meta.path;
}

const _home = PageLink('Início', AppRoutes.root);

List<SitePage> buildSitePages(SeoCatalog catalog) {
  final pages = <SitePage>[
    ..._fixedPages(catalog),
    for (final category in catalog.categories) ..._categoryPages(category, catalog.posts),
    for (final post in catalog.posts) _postPage(post, _categoryOf(catalog, post)),
    for (final area in DocumentArea.values) ..._libraryAreaPages(area, catalog.documents),
    for (final document in catalog.documents) _documentPage(document),
    for (final member in catalog.members.where(memberHasPage)) _memberPage(member),
  ];
  _requireUniqueRoutes(pages);
  return pages;
}

List<SitePage> _fixedPages(SeoCatalog catalog) {
  SitePage fixed(PageMeta meta, String heading, {List<PageLink> links = const []}) => SitePage(
        kind: PageKind.fixed,
        meta: meta,
        heading: heading,
        paragraphs: [meta.description],
        links: links,
        breadcrumbs: [_home, PageLink(heading, meta.path)],
      );

  final categoryLinks = [
    for (final category in catalog.categories)
      PageLink(category.title, AppRoutes.category(category.areas.first.key, category.key)),
  ];
  final libraryLinks = [
    for (final area in DocumentArea.values)
      PageLink('Biblioteca de ${area.value}', AppRoutes.libraryArea(area.routeKey)),
  ];

  return [
    SitePage(
      kind: PageKind.home,
      meta: RouteMeta.home,
      heading: siteName,
      paragraphs: [RouteMeta.home.description],
      links: [
        const PageLink('Todas as publicações', AppRoutes.publications),
        const PageLink('Biblioteca', AppRoutes.library),
        const PageLink('Nossa história', AppRoutes.ourHistory),
        const PageLink('Manifesto', AppRoutes.manifesto),
        const PageLink('Fale com a gente', AppRoutes.contact),
        const PageLink('Colabore', AppRoutes.collaborate),
        ...categoryLinks,
      ],
    ),
    fixed(RouteMeta.ourHistory, 'Nossa história'),
    fixed(RouteMeta.manifesto, 'Manifesto'),
    fixed(RouteMeta.contact, 'Fale com a gente'),
    fixed(RouteMeta.collaborate, 'Colabore'),
    fixed(RouteMeta.publications, 'Todas as publicações', links: categoryLinks),
    fixed(RouteMeta.library, 'Biblioteca', links: libraryLinks),
  ];
}

CategoryModel _categoryOf(SeoCatalog catalog, PostModel post) =>
    catalog.categories.firstWhere((category) => category.key == post.categoryId);

/// Newest first, like the app; items without a date go last and ties break by id.
int _newestFirst(DateTime? a, DateTime? b, String? idA, String? idB) {
  if (a != null && b != null) {
    final byDate = b.compareTo(a);
    if (byDate != 0) return byDate;
  } else if (a != null || b != null) {
    return a == null ? 1 : -1;
  }
  return (idA ?? '').compareTo(idB ?? '');
}

List<List<T>> paginate<T>(List<T> items, {int size = listingPageSize}) {
  if (items.isEmpty) return [<T>[]];
  return [
    for (var start = 0; start < items.length; start += size)
      items.sublist(start, (start + size).clamp(0, items.length))
  ];
}

DateTime? _newest(Iterable<DateTime?> dates) {
  DateTime? newest;
  for (final date in dates) {
    if (date != null && (newest == null || date.isAfter(newest))) newest = date;
  }
  return newest;
}

String _pageTitle(String title, int page) {
  if (page <= 1) return title;
  const suffix = ' | Observatório';
  return title.endsWith(suffix)
      ? '${title.substring(0, title.length - suffix.length)} (página $page)$suffix'
      : '$title (página $page)';
}

PageMeta _pageMeta(PageMeta base, String route, int page) => PageMeta(
      title: _pageTitle(base.title, page),
      description: page <= 1 ? base.description : summarize('Página $page. ${base.description}'),
      path: route,
    );

List<SitePage> _categoryPages(CategoryModel category, List<PostModel> allPosts) {
  final area = category.areas.first;
  final posts = allPosts.where((post) => post.categoryId == category.key).toList()
    ..sort((a, b) => _newestFirst(a.createdAt, b.createdAt, a.id, b.id));
  final base = RouteMeta.category(area, category);
  final chunks = paginate(posts);
  String routeOf(int page) => AppRoutes.categoryPage(area.key, category.key, page);

  return [
    for (var index = 0; index < chunks.length; index++)
      SitePage(
        kind: PageKind.collection,
        meta: _pageMeta(base, routeOf(index + 1), index + 1),
        heading: category.title,
        paragraphs: [category.description.trim().isEmpty ? base.description : category.description],
        breadcrumbs: [_home, PageLink(category.title, routeOf(1))],
        links: [for (final post in chunks[index]) PageLink(post.body!.title, _postRoute(post))],
        previous: index == 0 ? null : routeOf(index),
        next: index == chunks.length - 1 ? null : routeOf(index + 2),
        lastModified: _newest(chunks[index].map((post) => post.updatedAt)),
      ),
  ];
}

String _postRoute(PostModel post) =>
    AppRoutes.post(post.areas.first.key, post.categoryId, post.id!);

SitePage _postPage(PostModel post, CategoryModel category) {
  final body = post.body;
  if (body == null || post.id == null) {
    throw SeoException('Post ${post.categoryId}/${post.id} sem corpo ou sem id.');
  }
  final area = post.areas.first;
  final meta = RouteMeta.post(post, fallbackArea: area);
  final paragraphs = switch (body) {
    final ArticleModel article => [
        article.subtitle,
        plainTextFromRich(article.content),
        plainTextFromRich(article.observation ?? ''),
      ],
    _ => [RouteMeta.postDescription(post)],
  };

  return SitePage(
    kind: PageKind.post,
    meta: meta,
    heading: body.title,
    paragraphs: [
      for (final text in paragraphs)
        if (text.trim().isNotEmpty) text.trim(),
    ],
    breadcrumbs: [
      _home,
      PageLink(category.title, AppRoutes.categoryPage(category.areas.first.key, category.key, 1)),
      PageLink(body.title, meta.path),
    ],
    facts: [
      PageFact('Tipo', post.type.portuguese),
      PageFact('Categoria', category.title),
      if (body is ArticleModel && body.authors.isNotEmpty)
        PageFact('Autoria', body.authors.join(', ')),
    ],
    lastModified: post.updatedAt,
    schema: {
      '@type': post.isArticle ? 'Article' : 'CreativeWork',
      'headline': body.title,
      if (post.createdAt != null) 'datePublished': post.createdAt!.toUtc().toIso8601String(),
      if (post.updatedAt != null) 'dateModified': post.updatedAt!.toUtc().toIso8601String(),
      if (body is ArticleModel && body.authors.isNotEmpty)
        'author': [
          for (final author in body.authors) {'@type': 'Person', 'name': author},
        ],
      if (body.image.url != null && body.image.url!.isNotEmpty) 'image': body.image.url,
    },
  );
}

List<SitePage> _libraryAreaPages(DocumentArea area, List<LibraryDocumentModel> allDocuments) {
  final documents = allDocuments.where((document) => document.area == area).toList()
    ..sort((a, b) => _newestFirst(a.createdAt, b.createdAt, a.id, b.id));
  final base = RouteMeta.libraryArea(area);
  final chunks = paginate(documents);
  String routeOf(int page) => AppRoutes.libraryAreaPage(area.routeKey, page);

  return [
    for (var index = 0; index < chunks.length; index++)
      SitePage(
        kind: PageKind.collection,
        meta: _pageMeta(base, routeOf(index + 1), index + 1),
        heading: 'Biblioteca de ${area.value}',
        paragraphs: [base.description],
        breadcrumbs: [
          _home,
          const PageLink('Biblioteca', AppRoutes.library),
          PageLink('Biblioteca de ${area.value}', routeOf(1)),
        ],
        links: [
          for (final document in chunks[index])
            PageLink(document.title, AppRoutes.libraryDocument(area.routeKey, document.id!)),
        ],
        previous: index == 0 ? null : routeOf(index),
        next: index == chunks.length - 1 ? null : routeOf(index + 2),
        lastModified: _newest(chunks[index].map((document) => document.createdAt)),
      ),
  ];
}

SitePage _documentPage(LibraryDocumentModel document) {
  final id = document.id!;
  final meta = RouteMeta.libraryDocument(document, fallbackKey: id);
  final areaRoute = AppRoutes.libraryArea(document.area.routeKey);
  final institution = document.institution?.trim() ?? '';

  return SitePage(
    kind: PageKind.document,
    meta: meta,
    heading: document.title,
    paragraphs: [meta.description],
    breadcrumbs: [
      _home,
      const PageLink('Biblioteca', AppRoutes.library),
      PageLink('Biblioteca de ${document.area.value}', areaRoute),
      PageLink(document.title, meta.path),
    ],
    facts: [
      PageFact('Autoria', document.author),
      if (institution.isNotEmpty) PageFact('Instituição', institution),
      if (document.year != null) PageFact('Ano', '${document.year}'),
      if (document.type != null) PageFact('Tipo', document.type!.value),
      PageFact('Área', document.area.value),
    ],
    lastModified: document.createdAt,
    schema: {
      '@type': 'Thesis',
      'name': document.title,
      'author': {'@type': 'Person', 'name': document.author},
      if (institution.isNotEmpty)
        'sourceOrganization': {'@type': 'Organization', 'name': institution},
      if (document.year != null) 'datePublished': '${document.year}',
    },
  );
}

SitePage _memberPage(TeamMemberModel member) {
  final meta = RouteMeta.member(member, member.id!);
  return SitePage(
    kind: PageKind.member,
    meta: meta,
    heading: member.name,
    paragraphs: [member.description!.trim()],
    breadcrumbs: [_home, PageLink(member.name, meta.path)],
    facts: [PageFact('Função', member.role)],
    schema: {'@type': 'Person', 'name': member.name, 'jobTitle': member.role},
  );
}

void _requireUniqueRoutes(List<SitePage> pages) {
  final seen = <String>{};
  for (final page in pages) {
    if (!seen.add(page.route)) {
      throw SeoException('Dois conteúdos com o mesmo endereço: ${page.route}');
    }
  }
}
