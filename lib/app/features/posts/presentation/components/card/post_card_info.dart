import 'package:observatorio_geo_hist/app/core/models/academic_production_model.dart';
import 'package:observatorio_geo_hist/app/core/models/article_model.dart';
import 'package:observatorio_geo_hist/app/core/models/book_model.dart';
import 'package:observatorio_geo_hist/app/core/models/document_model.dart';
import 'package:observatorio_geo_hist/app/core/models/event_model.dart';
import 'package:observatorio_geo_hist/app/core/models/film_model.dart';
import 'package:observatorio_geo_hist/app/core/models/magazine_model.dart';
import 'package:observatorio_geo_hist/app/core/models/music_model.dart';
import 'package:observatorio_geo_hist/app/core/models/podcast_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/models/search_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/date/date.dart';
import 'package:observatorio_geo_hist/app/core/utils/strings/plain_text.dart';
import 'package:observatorio_geo_hist/app/core/utils/strings/strings.dart';

typedef PostCardInfo = ({
  String label,
  String title,
  String imageUrl,
  String summary,
  String meta,
});

PostCardInfo postCardInfo(PostModel post) {
  final body = post.body;

  final (String summary, List<String> meta) = switch (body) {
    ArticleModel() => (
        body.subtitle,
        [joinNames(body.authors), formatMonthYear(body.date)],
      ),
    BookModel() => (body.synopsis, [body.author, _year(body.year)]),
    FilmModel() => (
        plainTextFromRich(body.synopsis),
        [
          if (body.director.trim().isNotEmpty) 'Direção: ${body.director.trim()}',
          _year(body.releaseYear),
        ],
      ),
    EventModel() => (body.details ?? '', [body.date, body.city]),
    PodcastModel() => (body.description, const <String>[]),
    MusicModel() => (body.description, [body.artistName]),
    MagazineModel() => (
        (body.teaser?.trim().isNotEmpty ?? false) ? body.teaser! : body.description,
        const <String>[],
      ),
    DocumentModel() => (plainTextFromRich(body.description), const <String>[]),
    AcademicProductionModel() => (
        body.summary,
        [body.author, body.yearAndCity],
      ),
    SearchModel() => (body.description, [body.state.portuguese]),
    _ => ('', const <String>[]),
  };

  return (
    label: post.type.portuguese.toUpperCase(),
    title: body?.title.trim() ?? '',
    imageUrl: body?.image.url?.trim() ?? '',
    summary: summary.trim(),
    meta: meta.map((part) => part.trim()).where((part) => part.isNotEmpty).join(' · '),
  );
}

String _year(int year) => year > 0 ? '$year' : '';
