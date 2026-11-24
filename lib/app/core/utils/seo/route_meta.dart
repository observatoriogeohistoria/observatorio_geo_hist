import 'package:observatorio_geo_hist/app/core/models/academic_production_model.dart';
import 'package:observatorio_geo_hist/app/core/models/article_model.dart';
import 'package:observatorio_geo_hist/app/core/models/book_model.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/document_model.dart';
import 'package:observatorio_geo_hist/app/core/models/event_model.dart';
import 'package:observatorio_geo_hist/app/core/models/film_model.dart';
import 'package:observatorio_geo_hist/app/core/models/magazine_model.dart';
import 'package:observatorio_geo_hist/app/core/models/music_model.dart';
import 'package:observatorio_geo_hist/app/core/models/podcast_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/models/search_model.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/browser/page_meta_data.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/strings/plain_text.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';

abstract class RouteMeta {
  static const _homeTitle = '$siteName | UFU';
  static const _homeDescription =
      'Pesquisas, materiais e recursos para o ensino de História e Geografia. '
      'Projeto da Faculdade de Educação da UFU.';

  static PageMeta _titled(String title, String description, String path, {bool noIndex = false}) =>
      PageMeta(
        title: '$title | Observatório',
        description: summarize(description),
        path: path,
        noIndex: noIndex,
      );

  static const home = PageMeta(title: _homeTitle, description: _homeDescription, path: '/');

  static final ourHistory = _titled(
    'Nossa história',
    'Como o Observatório do Ensino de História e Geografia nasceu na UFU e o que o move.',
    AppRoutes.ourHistory,
  );

  static final contact = _titled(
    'Fale com a gente',
    'Contato com a equipe do Observatório do Ensino de História e Geografia.',
    AppRoutes.contact,
  );

  static final collaborate = _titled(
    'Colabore',
    'Envie artigos, relatos e materiais para as publicações do Observatório.',
    AppRoutes.collaborate,
  );

  static final manifesto = _titled(
    'Manifesto',
    'O manifesto do Observatório do Ensino de História e Geografia.',
    AppRoutes.manifesto,
  );

  static final publications = _titled(
    'Todas as publicações',
    'Artigos, livros, filmes, eventos e outros materiais de todas as categorias de História e '
        'Geografia.',
    AppRoutes.publications,
  );

  static final library = _titled(
    'Biblioteca',
    'Teses e dissertações sobre História e Geografia, de várias instituições e pesquisadores, '
        'reunidas em um só lugar.',
    AppRoutes.library,
  );

  static PageMeta notFound(String path) => _titled(
        'Página não encontrada',
        'O endereço pode ter mudado ou o conteúdo foi removido.',
        path,
        noIndex: true,
      );

  static PageMeta category(PostsAreas area, CategoryModel category) => _titled(
        '${category.title} de ${area.portuguese}',
        category.description.trim().isEmpty
            ? 'Publicações de ${category.title} sobre ensino de ${area.portuguese}.'
            : category.description,
        AppRoutes.category(area.key, category.key),
      );

  static PageMeta categoryLoading(PostsAreas area, String categoryKey) => _titled(
        'Publicações de ${area.portuguese}',
        'Publicações sobre ensino de ${area.portuguese}.',
        AppRoutes.category(area.key, categoryKey),
      );

  /// Two areas share the same post: the canonical is the first one, as in the listings.
  static PageMeta post(PostModel post, {required PostsAreas fallbackArea}) {
    final body = post.body;
    final area = post.areas.isEmpty ? fallbackArea : post.areas.first;
    final path = AppRoutes.post(area.key, post.categoryId, post.id ?? '');
    if (body == null) return postLoading(area, post.categoryId, post.id ?? '');
    return _titled(body.title, _postDescription(post), path);
  }

  static PageMeta postLoading(PostsAreas area, String categoryKey, String postId) => _titled(
        'Publicação',
        'Publicação do Observatório do Ensino de História e Geografia.',
        AppRoutes.post(area.key, categoryKey, postId),
      );

  static PageMeta libraryArea(DocumentArea area) => _titled(
        'Biblioteca de ${area.value}',
        'Teses e dissertações sobre o ensino de ${area.value}, de várias instituições e '
            'pesquisadores.',
        AppRoutes.libraryArea(area.routeKey),
      );

  static PageMeta libraryDocument(LibraryDocumentModel document, {required String fallbackKey}) {
    final kind = document.type?.value ?? 'Documento';
    final details = [
      document.author,
      if (document.institution?.trim().isNotEmpty ?? false) document.institution!.trim(),
      if (document.year != null) '${document.year}',
    ].join(', ');
    return _titled(
      document.title,
      '$kind de $details. Biblioteca do Observatório, área de ${document.area.value}.',
      AppRoutes.libraryDocument(document.area.routeKey, document.id ?? fallbackKey),
    );
  }

  static PageMeta libraryDocumentLoading(DocumentArea area, String key) => _titled(
        'Documento',
        'Documento da biblioteca do Observatório, área de ${area.value}.',
        AppRoutes.libraryDocument(area.routeKey, key),
      );

  static PageMeta member(TeamMemberModel member, String memberId) => _titled(
        member.name,
        (member.description?.trim().isNotEmpty ?? false)
            ? member.description!
            : '${member.name}, ${member.role} no Observatório do Ensino de História e Geografia.',
        AppRoutes.member(memberId),
      );

  static PageMeta memberLoading(String memberId) => _titled(
        'Equipe',
        'Equipe do Observatório do Ensino de História e Geografia.',
        AppRoutes.member(memberId),
      );

  static String _postDescription(PostModel post) {
    final body = post.body;
    final text = switch (body) {
      final ArticleModel article =>
        article.subtitle.trim().isNotEmpty ? article.subtitle : plainTextFromRich(article.content),
      final EventModel event => event.details ?? '',
      final FilmModel film => film.synopsis,
      final BookModel book => book.synopsis,
      final PodcastModel podcast => podcast.description,
      final MusicModel music => music.description,
      final DocumentModel document => document.description,
      final MagazineModel magazine => magazine.description,
      final AcademicProductionModel academic => academic.summary,
      final SearchModel search => search.description,
      _ => '',
    };
    return text.trim().isEmpty
        ? 'Publicação do Observatório do Ensino de História e Geografia.'
        : text;
  }
}
