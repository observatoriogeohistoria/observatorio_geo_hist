import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/models/music_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_form.dart';

class MusicEditorForm extends PostEditorForm {
  MusicEditorForm(this.body);

  final MusicModel? body;

  late final _title = input('Nome da música', body?.title, isTitle: true);
  late final _artist = input('Nome do artista', body?.artistName);
  late final _description = input('Descrição', body?.description, lines: 3);
  late final _lyrics = rich('Letra', body?.lyrics, isRequired: false);
  late final _link = input('Link', body?.link,
      validator: Validators.isValidUrl, hintText: 'https://', keyboardType: TextInputType.url);

  @override
  FocusNode get firstFocus => _title.focusNode;

  @override
  List<PostEditorField> get mainFields => [
        _title.field,
        _artist.field,
        _description.field,
        _lyrics.field,
        _link.field,
      ];

  @override
  List<Widget> buildMain(BuildContext context) => [
        PostEditorCard(
          children: [
            _title.build(context),
            _artist.build(context),
            _description.build(context),
          ],
        ),
        PostEditorCard(
          children: [
            _lyrics.build(context),
            _link.build(context),
          ],
        ),
      ];

  @override
  PostBody buildBody(PostEditorImage image) => MusicModel(
        title: _title.text,
        artistName: _artist.text,
        image: image.value,
        description: _description.text,
        lyrics: _lyrics.json,
        link: _link.text,
      );
}
