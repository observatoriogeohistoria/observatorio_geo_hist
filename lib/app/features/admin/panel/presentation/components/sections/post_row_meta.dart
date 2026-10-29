import 'package:observatorio_geo_hist/app/core/models/academic_production_model.dart';
import 'package:observatorio_geo_hist/app/core/models/article_model.dart';
import 'package:observatorio_geo_hist/app/core/models/book_model.dart';
import 'package:observatorio_geo_hist/app/core/models/event_model.dart';
import 'package:observatorio_geo_hist/app/core/models/film_model.dart';
import 'package:observatorio_geo_hist/app/core/models/music_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/models/search_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/strings/strings.dart';

/// "Área · Categoria" and, when the type has them, who made it and when. Empty parts are dropped.
String postRowMeta(PostModel post) {
  final body = post.body;
  final details = switch (body) {
    ArticleModel() => [joinNames(body.authors), body.date],
    BookModel() => [body.author, '${body.year}'],
    AcademicProductionModel() => [body.author, body.yearAndCity],
    FilmModel() => [body.director, '${body.releaseYear}'],
    MusicModel() => [body.artistName],
    EventModel() => [body.date],
    SearchModel() => [body.coordinator ?? ''],
    _ => <String>[],
  };

  return [
    post.areas.map((area) => area.portuguese).join(' e '),
    post.category?.title ?? '',
    ...details,
  ].map((part) => part.trim()).where((part) => part.isNotEmpty && part != '0').join(' · ');
}

String postRowTitle(PostModel post) {
  final title = post.body?.title.trim() ?? '';
  return title.isEmpty ? 'Sem título' : title;
}
