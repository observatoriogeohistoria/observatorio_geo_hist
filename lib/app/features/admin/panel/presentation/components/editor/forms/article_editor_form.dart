import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:observatorio_geo_hist/app/core/components/form/form_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/quill/editor_quill.dart';
import 'package:observatorio_geo_hist/app/core/models/article_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/formatters/mont_year_input_formatter.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_authors.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_form.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_validators.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class ArticleEditorForm extends PostEditorForm {
  ArticleEditorForm(ArticleModel? body) {
    _title = text(body?.title);
    _subtitle = text(body?.subtitle);
    _date = text(body?.date);
    _content = richText(body?.content);
    _observation = richText(body?.observation);
    final names = body?.authors ?? const [];
    for (final name in names.isEmpty ? [''] : names) {
      _authors.add(_newAuthor(name));
    }
  }

  late final TextEditingController _title;
  late final TextEditingController _subtitle;
  late final TextEditingController _date;
  late final QuillController _content;
  late final QuillController _observation;
  final List<PostEditorAuthor> _authors = [];

  late final _titleFocus = focus();
  late final _subtitleFocus = focus();
  late final _contentFocus = focus();
  late final _observationFocus = focus();
  late final _dateFocus = focus();

  final _titleKey = GlobalKey<FormFieldState<String>>();
  final _subtitleKey = GlobalKey<FormFieldState<String>>();
  final _contentKey = GlobalKey<FormFieldState<void>>();
  final _observationKey = GlobalKey<FormFieldState<void>>();
  final _dateKey = GlobalKey<FormFieldState<String>>();

  PostEditorAuthor _newAuthor(String name) =>
      PostEditorAuthor(text(name), focus(), GlobalKey<FormFieldState<String>>());

  @override
  bool get hasCaption => true;

  @override
  FocusNode get firstFocus => _titleFocus;

  @override
  List<PostEditorField> get mainFields => [
        PostEditorField(_titleKey, 'Título', _titleFocus),
        PostEditorField(_subtitleKey, 'Subtítulo', _subtitleFocus),
        PostEditorField(_contentKey, 'Texto', _contentFocus),
        PostEditorField(_observationKey, 'Observação', _observationFocus),
      ];

  @override
  List<PostEditorField> get sideFields => [
        for (final (index, author) in _authors.indexed)
          PostEditorField(author.fieldKey, 'Autor ${index + 1}', author.focusNode),
        PostEditorField(_dateKey, 'Data', _dateFocus),
      ];

  void _addAuthor() {
    final author = _newAuthor('');
    _authors.add(author);
    edited();
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) => author.focusNode.requestFocus());
  }

  void _removeAuthor(int index) {
    if (_authors.length == 1) return;
    _authors.removeAt(index);
    edited();
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) => _authors.first.focusNode.requestFocus());
  }

  @override
  List<Widget> buildMain(BuildContext context) {
    final components = AppTheme.dimensions.components;

    return [
      PostEditorCard(
        children: [
          FormTextField(
            label: 'Título',
            controller: _title,
            focusNode: _titleFocus,
            formFieldKey: _titleKey,
            validator: PanelValidators.title,
            style: AppTheme.typography.of(context).editorTitleField,
          ),
          FormTextField(
            label: 'Subtítulo',
            controller: _subtitle,
            focusNode: _subtitleFocus,
            formFieldKey: _subtitleKey,
            validator: PanelValidators.required,
          ),
          PostEditorRichText(
            fieldKey: _contentKey,
            controller: _content,
            focusNode: _contentFocus,
            label: 'Texto',
            placeholder: 'Escreva o texto da publicação…',
            minHeight: components.richTextMinHeight,
            onEdited: edited,
          ),
        ],
      ),
      PostEditorCard(
        children: [
          PostEditorRichText(
            fieldKey: _observationKey,
            controller: _observation,
            focusNode: _observationFocus,
            label: 'Observação',
            isRequired: false,
            helperText: 'Aparece no bloco “Nota”, ao fim do texto.',
            onEdited: edited,
          ),
        ],
      ),
    ];
  }

  @override
  Widget buildSide(BuildContext context) {
    return PostEditorCard(
      eyebrow: 'Autoria',
      children: [
        PostEditorAuthors(authors: _authors, onAdd: _addAuthor, onRemove: _removeAuthor),
        FormTextField(
          label: 'Data',
          controller: _date,
          focusNode: _dateFocus,
          formFieldKey: _dateKey,
          hintText: 'MM/AAAA',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
            MonthYearInputFormatter(),
          ],
          validator: Validators.isValidMonthAndYear,
        ),
      ],
    );
  }

  @override
  PostBody buildBody(PostEditorImage image) {
    return ArticleModel(
      title: _title.text,
      image: image.value,
      subtitle: _subtitle.text,
      authors: _authors.map((author) => author.controller.text).toList(),
      date: _date.text,
      imageCaption: image.caption.text,
      content: EditorQuill.toJson(_content),
      observation: EditorQuill.toJson(_observation),
    );
  }
}
