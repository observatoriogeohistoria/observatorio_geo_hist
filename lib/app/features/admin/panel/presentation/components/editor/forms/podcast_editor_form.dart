import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/models/podcast_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_form.dart';

class PodcastEditorForm extends PostEditorForm {
  PodcastEditorForm(this.body);

  final PodcastModel? body;

  late final _title = input('Título', body?.title, isTitle: true);
  late final _description = input('Descrição', body?.description, lines: 5);
  late final _link = input('Link', body?.link,
      validator: Validators.isValidUrl, hintText: 'https://', keyboardType: TextInputType.url);

  @override
  FocusNode get firstFocus => _title.focusNode;

  @override
  List<PostEditorField> get mainFields => [
        _title.field,
        _description.field,
        _link.field,
      ];

  @override
  List<Widget> buildMain(BuildContext context) => [
        PostEditorCard(
          children: [
            _title.build(context),
            _description.build(context),
            _link.build(context),
          ],
        ),
      ];

  @override
  PostBody buildBody(PostEditorImage image) => PodcastModel(
        title: _title.text,
        image: image.value,
        description: _description.text,
        link: _link.text,
      );
}
