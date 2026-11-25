import 'package:flutter_test/flutter_test.dart';

import 'catalog_fixtures.dart';
import 'rest_fixtures.dart';
import 'seo_exception.dart';
import 'site_pages.dart';

List<SitePage> _collections(List<SitePage> pages, String prefix) =>
    pages.where((p) => p.kind == PageKind.collection && p.route.startsWith(prefix)).toList();

void main() {
  test('a category with 120 posts has 3 pages of 50, 50 and 20, with no repeated item', () async {
    final pages = buildSitePages(await fakeCatalog(postCount: 120));
    final listing = _collections(pages, '/publicacoes/historia/9');

    expect(listing.map((p) => p.route), [
      '/publicacoes/historia/9',
      '/publicacoes/historia/9/pagina/2',
      '/publicacoes/historia/9/pagina/3',
    ]);
    expect(listing.map((p) => p.links.length), [50, 50, 20]);
    final routes = listing.expand((p) => p.links.map((l) => l.route)).toList();
    expect(routes.toSet(), hasLength(120));
  });

  test('previous and next point to the neighbour pages', () async {
    final listing = _collections(
      buildSitePages(await fakeCatalog(postCount: 120)),
      '/publicacoes/historia/9',
    );

    expect(listing[0].previous, isNull);
    expect(listing[0].next, '/publicacoes/historia/9/pagina/2');
    expect(listing[1].previous, '/publicacoes/historia/9');
    expect(listing[1].next, '/publicacoes/historia/9/pagina/3');
    expect(listing[2].next, isNull);
  });

  test('each listing page is its own canonical and the next ones say which page they are',
      () async {
    final listing = _collections(
      buildSitePages(await fakeCatalog(postCount: 51)),
      '/publicacoes/historia/9',
    );

    expect(listing, hasLength(2));
    expect(listing[1].meta.canonicalUrl('https://x.test'),
        'https://x.test/publicacoes/historia/9/pagina/2');
    expect(listing[1].meta.title, contains('(página 2) | Observatório'));
    expect(listing[0].meta.title, isNot(contains('página')));
  });

  test('50 items make one page; a category with no posts still has its page', () async {
    expect(
        _collections(buildSitePages(await fakeCatalog(postCount: 50)), '/publicacoes/historia/9'),
        hasLength(1));
    expect(paginate(<int>[]), [<int>[]]);
    expect(paginate(List.generate(51, (i) => i)).map((p) => p.length), [50, 1]);
  });

  test('a post page is canonical under its first area and carries post data', () async {
    final pages = buildSitePages(await fakeCatalog(postCount: 2));
    final post = pages.firstWhere((p) => p.kind == PageKind.post);

    expect(post.route, '/publicacoes/historia/9/p000');
    expect(post.heading, 'Artigo 0');
    expect(post.paragraphs, contains('Texto do artigo'));
    expect(post.schema['@type'], 'Article');
    expect(post.lastModified, DateTime.utc(2026, 1, 2));
  });

  test('the listing is newest first and lastModified is the newest update on the page', () async {
    final pages = buildSitePages(await fakeCatalog(postCount: 3));
    final listing = pages.firstWhere((p) => p.route == '/publicacoes/historia/9');

    expect(listing.links.map((l) => l.title), ['Artigo 2', 'Artigo 1', 'Artigo 0']);
    expect(listing.lastModified, DateTime.utc(2026, 1, 4));
  });

  test('library documents use the Firestore id and createdAt for lastModified', () async {
    final pages = buildSitePages(await fakeCatalog(documentCount: 2));
    final document = pages.firstWhere((p) => p.kind == PageKind.document);

    expect(document.route, '/biblioteca/historia/documento/Doc0');
    expect(document.lastModified, DateTime.utc(2026, 1, 1));
    expect(document.schema['@type'], 'Thesis');
  });

  test('the library has a page for each area, even one without documents', () async {
    final pages = buildSitePages(await fakeCatalog(documentCount: 1));

    expect(
        pages.map((p) => p.route), containsAll(['/biblioteca/historia', '/biblioteca/geografia']));
  });

  test('only members with a page are listed', () async {
    Map<String, dynamic> member(String path, String? description) => {
          'name': 'Bia',
          'role': 'Bolsista',
          'description': description ?? '',
          'lattesUrl': 'https://x.test/l',
          'image': 'https://x.test/i.png',
        };
    final pages = buildSitePages(
      await fakeCatalog(
        team: [
          rawDocument('team/m1', member('m1', 'Texto')),
          rawDocument('team/m2', member('m2', null)),
        ],
      ),
    );

    expect(pages.where((p) => p.kind == PageKind.member).map((p) => p.route), ['/membro/m1']);
  });

  test('has the fixed pages and every route is unique', () async {
    final pages = buildSitePages(await fakeCatalog());

    expect(
      pages.map((p) => p.route),
      containsAll([
        '/',
        '/nossa-historia',
        '/manifesto',
        '/contato',
        '/colaborar',
        '/publicacoes',
        '/biblioteca',
      ]),
    );
    expect(pages.map((p) => p.route).toSet(), hasLength(pages.length));
  });

  test('duplicate routes stop the run', () async {
    final catalog = await fakeCatalog();

    expect(
      () => buildSitePages(
        catalog.copyWithPosts([...catalog.posts, catalog.posts.first]),
      ),
      throwsA(isA<SeoException>()),
    );
  });
}
