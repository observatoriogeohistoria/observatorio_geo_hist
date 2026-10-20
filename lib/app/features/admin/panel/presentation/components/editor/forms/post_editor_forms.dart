import 'package:observatorio_geo_hist/app/core/models/article_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/forms/article_editor_form.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_form.dart';

PostEditorForm? postEditorFormFor(PostType type, PostBody? body) => switch (type) {
      PostType.article => ArticleEditorForm(body as ArticleModel?),
      _ => null,
    };

String? postEditorCaptionOf(PostBody? body) => switch (body) {
      ArticleModel(:final imageCaption) => imageCaption,
      _ => null,
    };
