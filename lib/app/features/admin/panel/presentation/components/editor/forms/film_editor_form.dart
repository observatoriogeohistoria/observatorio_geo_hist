import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/models/film_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_form.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_validators.dart';

class FilmEditorForm extends PostEditorForm {
  FilmEditorForm(this.body);

  final FilmModel? body;

  late final _title = input('Título', body?.title, isTitle: true);
  late final _category = choice(
      'Categoria', FilmCategory.values, (value) => value.portuguese, body?.category,
      placeholder: 'Escolha a categoria', message: PanelValidators.categoryMessage);
  late final _year = input('Ano de lançamento', body?.releaseYear.toString(),
      validator: Validators.isValidYear, keyboardType: TextInputType.number);
  late final _duration = input('Duração', body?.duration);
  late final _director = input('Direção', body?.director);
  late final _country = input('País', body?.country);
  late final _synopsis = rich('Sinopse', body?.synopsis);
  late final _link = input('Link', body?.link,
      validator: Validators.isValidUrl, hintText: 'https://', keyboardType: TextInputType.url);

  @override
  FocusNode get firstFocus => _title.focusNode;

  @override
  List<PostEditorField> get mainFields => [
        _title.field,
        _category.field,
        _year.field,
        _duration.field,
        _director.field,
        _country.field,
        _synopsis.field,
        _link.field,
      ];

  @override
  List<Widget> buildMain(BuildContext context) => [
        PostEditorCard(
          children: [
            _title.build(context),
            _category.build(context),
            _year.build(context),
            _duration.build(context),
            _director.build(context),
            _country.build(context),
          ],
        ),
        PostEditorCard(
          children: [
            _synopsis.build(context),
            _link.build(context),
          ],
        ),
      ];

  @override
  PostBody buildBody(PostEditorImage image) => FilmModel(
        category: _category.value!,
        title: _title.text,
        image: image.value,
        releaseYear: int.parse(_year.text),
        duration: _duration.text,
        director: _director.text,
        country: _country.text,
        synopsis: _synopsis.json,
        link: _link.text,
      );
}
