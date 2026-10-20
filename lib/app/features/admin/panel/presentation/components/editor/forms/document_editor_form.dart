import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/models/document_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_form.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_validators.dart';

class DocumentEditorForm extends PostEditorForm {
  DocumentEditorForm(this.body);

  final DocumentModel? body;

  late final _title = input('Título', body?.title, isTitle: true);
  late final _category = choice(
      'Categoria', DocumentCategory.values, (value) => value.portuguese, body?.category,
      placeholder: 'Escolha a categoria', message: PanelValidators.categoryMessage);
  late final _description = rich('Descrição', body?.description);
  late final _link = input('Link', body?.link,
      validator: Validators.isValidUrl, hintText: 'https://', keyboardType: TextInputType.url);

  @override
  FocusNode get firstFocus => _title.focusNode;

  @override
  List<PostEditorField> get mainFields => [
        _title.field,
        _category.field,
        _description.field,
        _link.field,
      ];

  @override
  List<Widget> buildMain(BuildContext context) => [
        PostEditorCard(
          children: [
            _title.build(context),
            _category.build(context),
          ],
        ),
        PostEditorCard(
          children: [
            _description.build(context),
            _link.build(context),
          ],
        ),
      ];

  @override
  PostBody buildBody(PostEditorImage image) => DocumentModel(
        category: _category.value!,
        title: _title.text,
        image: image.value,
        description: _description.json,
        link: _link.text,
      );
}
