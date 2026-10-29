import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/models/academic_production_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_form.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_validators.dart';

class AcademicProductionEditorForm extends PostEditorForm {
  AcademicProductionEditorForm(this.body);

  final AcademicProductionModel? body;

  late final _title = input('Título', body?.title, isTitle: true);
  late final _category = choice(
      'Categoria', AcademicProductionCategory.values, (value) => value.portuguese, body?.category,
      placeholder: 'Escolha a categoria', message: PanelValidators.categoryMessage);
  late final _author = input('Autor', body?.author);
  late final _advisor = input('Orientador', body?.advisor);
  late final _institution = input('Instituição', body?.institution);
  late final _yearAndCity =
      input('Cidade e ano de publicação', body?.yearAndCity, hintText: 'Ex: São Paulo, 2021');
  late final _summary = input('Resumo', body?.summary, lines: 6);
  late final _keywords = input('Palavras-chave', body?.keywords, hintText: 'Separe com vírgulas');
  late final _link = input('Link da pesquisa', body?.link,
      validator: Validators.isValidUrl, hintText: 'https://', keyboardType: TextInputType.url);

  @override
  FocusNode get firstFocus => _title.focusNode;

  @override
  List<PostEditorField> get mainFields => [
        _title.field,
        _category.field,
        _author.field,
        _advisor.field,
        _institution.field,
        _yearAndCity.field,
        _summary.field,
        _keywords.field,
        _link.field,
      ];

  @override
  List<Widget> buildMain(BuildContext context) => [
        PostEditorCard(
          children: [
            _title.build(context),
            _category.build(context),
            _author.build(context),
            _advisor.build(context),
            _institution.build(context),
            _yearAndCity.build(context),
          ],
        ),
        PostEditorCard(
          children: [
            _summary.build(context),
            _keywords.build(context),
            _link.build(context),
          ],
        ),
      ];

  @override
  PostBody buildBody(PostEditorImage image) => AcademicProductionModel(
        title: _title.text,
        category: _category.value!,
        author: _author.text,
        advisor: _advisor.text,
        image: image.value,
        institution: _institution.text,
        yearAndCity: _yearAndCity.text,
        summary: _summary.text,
        keywords: _keywords.text,
        link: _link.text,
      );
}
