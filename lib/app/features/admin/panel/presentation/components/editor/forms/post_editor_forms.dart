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
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/forms/academic_production_editor_form.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/forms/article_editor_form.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/forms/book_editor_form.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/forms/document_editor_form.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/forms/event_editor_form.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/forms/film_editor_form.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/forms/magazine_editor_form.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/forms/music_editor_form.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/forms/podcast_editor_form.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/forms/search_editor_form.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_form.dart';

PostEditorForm postEditorFormFor(PostType type, PostBody? body) => switch (type) {
      PostType.article => ArticleEditorForm(body as ArticleModel?),
      PostType.academicProduction => AcademicProductionEditorForm(body as AcademicProductionModel?),
      PostType.book => BookEditorForm(body as BookModel?),
      PostType.document => DocumentEditorForm(body as DocumentModel?),
      PostType.event => EventEditorForm(body as EventModel?),
      PostType.film => FilmEditorForm(body as FilmModel?),
      PostType.magazine => MagazineEditorForm(body as MagazineModel?),
      PostType.music => MusicEditorForm(body as MusicModel?),
      PostType.podcast => PodcastEditorForm(body as PodcastModel?),
      PostType.search => SearchEditorForm(body as SearchModel?),
    };

String? postEditorCaptionOf(PostBody? body) => switch (body) {
      ArticleModel(:final imageCaption) => imageCaption,
      SearchModel(:final imageCaption) => imageCaption,
      _ => null,
    };
