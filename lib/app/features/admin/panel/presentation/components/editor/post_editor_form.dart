import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:observatorio_geo_hist/app/core/components/quill/editor_quill.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/components/form/form_text_field.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/form_validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_select_field.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/listing/library_filter_select.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_validators.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Um campo na ordem da tela, para o resumo do que falta levar o foco e a rolagem até ele.
class PostEditorField {
  const PostEditorField(this.key, this.label, this.focusNode);

  final GlobalKey<FormFieldState> key;
  final String label;
  final FocusNode? focusNode;
}

/// Imagem e legenda ficam na coluna lateral, comum a todos os tipos, mas entram no corpo.
class PostEditorImage {
  PostEditorImage({String? url, String? caption})
      : url = TextEditingController(text: url),
        caption = TextEditingController(text: caption);

  final file = ValueNotifier<FileModel?>(null);
  final TextEditingController url;
  final TextEditingController caption;

  FileModel get value => FileModel(url: url.text, bytes: file.value?.bytes, name: file.value?.name);

  void dispose() {
    file.dispose();
    url.dispose();
    caption.dispose();
  }
}

/// Avisa a página de mudanças na estrutura (`notifyListeners`, para redesenhar) e no conteúdo
/// ([onEdited], para saber que há o que salvar).
abstract class PostEditorForm extends ChangeNotifier {
  VoidCallback? onEdited;

  final List<ChangeNotifier> _owned = [];
  final List<FocusNode> _focusNodes = [];

  bool get hasCaption => false;

  FocusNode get firstFocus;

  List<PostEditorField> get mainFields;

  /// Campos do cartão próprio do tipo na coluna lateral, que vem depois da imagem.
  List<PostEditorField> get sideFields => const [];

  List<Widget> buildMain(BuildContext context);

  Widget? buildSide(BuildContext context) => null;

  PostBody buildBody(PostEditorImage image);

  void edited() => onEdited?.call();

  void rebuild() => notifyListeners();

  PostEditorInput input(
    String label,
    String? initial, {
    FormValidator? validator = PanelValidators.required,
    bool isOptional = false,
    bool isTitle = false,
    String? hintText,
    TextInputType? keyboardType,
    int? lines,
  }) {
    return PostEditorInput(
      label,
      text(initial),
      focus(),
      validator: isOptional
          ? null
          : isTitle
              ? PanelValidators.title
              : validator,
      isOptional: isOptional,
      isTitle: isTitle,
      hintText: hintText,
      keyboardType: keyboardType,
      lines: lines,
    );
  }

  PostEditorChoice<T> choice<T>(
    String label,
    List<T> values,
    String Function(T) labelOf,
    T? initial, {
    required String placeholder,
    required String message,
  }) {
    return PostEditorChoice<T>(this, label, values, labelOf, initial, focus(),
        placeholder: placeholder, message: message);
  }

  PostEditorRich rich(String label, String? initial, {bool isRequired = true}) =>
      PostEditorRich(this, label, richText(initial), focus(), isRequired: isRequired);

  // Só o texto conta como alteração: o controlador também avisa ao mover o cursor.
  TextEditingController text(String? initial) {
    final controller = TextEditingController(text: initial);
    var last = controller.text;
    controller.addListener(() {
      if (controller.text == last) return;
      last = controller.text;
      edited();
    });
    _owned.add(controller);
    return controller;
  }

  QuillController richText(String? json) {
    final controller = EditorQuill.controllerFor(json);
    _owned.add(controller);
    return controller;
  }

  FocusNode focus() {
    final node = FocusNode();
    _focusNodes.add(node);
    return node;
  }

  @override
  void dispose() {
    for (final owned in _owned) {
      owned.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}

class PostEditorRichText extends StatelessWidget {
  const PostEditorRichText({
    required this.fieldKey,
    required this.controller,
    required this.focusNode,
    required this.label,
    this.isRequired = true,
    this.helperText,
    this.placeholder,
    this.minHeight,
    this.onEdited,
    super.key,
  });

  final GlobalKey<FormFieldState> fieldKey;
  final QuillController controller;
  final FocusNode focusNode;
  final String label;
  final bool isRequired;
  final String? helperText;
  final String? placeholder;
  final double? minHeight;
  final VoidCallback? onEdited;

  @override
  Widget build(BuildContext context) {
    return FormField<void>(
      key: fieldKey,
      validator: (_) =>
          isRequired && EditorQuill.isEmpty(controller) ? PanelValidators.textMessage : null,
      builder: (field) => EditorQuill(
        controller: controller,
        focusNode: focusNode,
        label: label,
        isOptional: !isRequired,
        helperText: helperText,
        placeholder: placeholder,
        minHeight: minHeight ?? AppTheme.dimensions.components.richTextMinHeightShort,
        errorText: field.errorText,
        onChanged: () {
          field.didChange(null);
          onEdited?.call();
        },
      ),
    );
  }
}

class PostEditorInput {
  PostEditorInput(
    this.label,
    this.controller,
    this.focusNode, {
    this.validator,
    this.isOptional = false,
    this.isTitle = false,
    this.hintText,
    this.keyboardType,
    this.lines,
  });

  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FormValidator? validator;
  final bool isOptional;
  final bool isTitle;
  final String? hintText;
  final TextInputType? keyboardType;

  /// Com valor, o campo é de várias linhas e começa com essa altura.
  final int? lines;

  final key = GlobalKey<FormFieldState<String>>();

  String get text => controller.text;

  PostEditorField get field => PostEditorField(key, label, focusNode);

  Widget build(BuildContext context) {
    final lines = this.lines;
    return FormTextField(
      label: label,
      controller: controller,
      focusNode: focusNode,
      formFieldKey: key,
      validator: validator,
      isOptional: isOptional,
      hintText: hintText,
      keyboardType: keyboardType,
      multiline: lines != null,
      minLines: lines,
      maxLines: lines == null ? null : AppTheme.dimensions.components.formMessageMaxLines,
      style: isTitle ? AppTheme.typography.of(context).editorTitleField : null,
    );
  }
}

class PostEditorChoice<T> {
  PostEditorChoice(
    this._form,
    this.label,
    this.values,
    this.labelOf,
    this.value,
    this.focusNode, {
    required this.placeholder,
    required this.message,
  });

  final PostEditorForm _form;
  final String label;
  final List<T> values;
  final String Function(T) labelOf;
  final FocusNode focusNode;
  final String placeholder;
  final String message;
  T? value;

  final key = GlobalKey<FormFieldState<T>>();

  PostEditorField get field => PostEditorField(key, label, focusNode);

  Widget build(BuildContext context) {
    return PanelSelectField<T>(
      label: label,
      options: [
        LibraryFilterOption<T?>(null, placeholder),
        for (final option in values) LibraryFilterOption<T?>(option, labelOf(option)),
      ],
      value: value,
      onSelected: (choice) {
        value = choice;
        _form.edited();
        _form.rebuild();
      },
      validator: PanelValidators.choice(message),
      formFieldKey: key,
      focusNode: focusNode,
    );
  }
}

class PostEditorRich {
  PostEditorRich(this._form, this.label, this.controller, this.focusNode, {this.isRequired = true});

  final PostEditorForm _form;
  final String label;
  final QuillController controller;
  final FocusNode focusNode;
  final bool isRequired;

  final key = GlobalKey<FormFieldState<void>>();

  String get json => EditorQuill.toJson(controller);

  PostEditorField get field => PostEditorField(key, label, focusNode);

  Widget build(BuildContext context) => PostEditorRichText(
        fieldKey: key,
        controller: controller,
        focusNode: focusNode,
        label: label,
        isRequired: isRequired,
        onEdited: _form.edited,
      );
}
