import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/models/book_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_form.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_validators.dart';

class BookEditorForm extends PostEditorForm {
  BookEditorForm(this.body);

  final BookModel? body;

  late final _title = input('Título', body?.title, isTitle: true);
  late final _category = choice(
      'Categoria', BookCategory.values, (value) => value.portuguese, body?.category,
      placeholder: 'Escolha a categoria', message: PanelValidators.categoryMessage);
  late final _author = input('Autor(a)', body?.author);
  late final _year = input('Ano de publicação', body?.year.toString(),
      validator: Validators.isValidYear, keyboardType: TextInputType.number);
  late final _publisher = input('Editora', body?.publisher);
  late final _synopsis = input('Chamada/Sinopse', body?.synopsis, lines: 4);
  late final _link = input('Link', body?.link,
      validator: Validators.isValidUrl, hintText: 'https://', keyboardType: TextInputType.url);

  @override
  FocusNode get firstFocus => _title.focusNode;

  @override
  List<PostEditorField> get mainFields => [
        _title.field,
        _category.field,
        _author.field,
        _year.field,
        _publisher.field,
        _synopsis.field,
        _link.field,
      ];

  @override
  List<Widget> buildMain(BuildContext context) => [
        PostEditorCard(
          children: [
            _title.build(context),
            _category.build(context),
            _author.build(context),
            _year.build(context),
            _publisher.build(context),
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
  PostBody buildBody(PostEditorImage image) => BookModel(
        category: _category.value!,
        title: _title.text,
        image: image.value,
        author: _author.text,
        year: int.parse(_year.text),
        publisher: _publisher.text,
        synopsis: _synopsis.text,
        link: _link.text,
      );
}
