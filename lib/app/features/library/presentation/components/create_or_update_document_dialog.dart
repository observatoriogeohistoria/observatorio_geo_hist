import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:observatorio_geo_hist/app/core/components/form/form_text_field.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_check_group.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_file_field.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_image_field.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_select_field.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_sheet.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_validators.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/listing/library_filter_select.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

Future<void> showCreateOrUpdateLibraryDocumentDialog(
  BuildContext context, {
  required DocumentArea area,
  required Future<String?> Function(LibraryDocumentModel document, FileModel file) onSave,
  LibraryDocumentModel? document,
}) {
  return showPanelSheet(
    context,
    builder: (_) => CreateOrUpdateLibraryDocumentDialog(
      area: area,
      onSave: onSave,
      document: document,
    ),
  );
}

class CreateOrUpdateLibraryDocumentDialog extends StatefulWidget {
  const CreateOrUpdateLibraryDocumentDialog({
    required this.area,
    required this.onSave,
    this.document,
    super.key,
  });

  final DocumentArea area;
  final Future<String?> Function(LibraryDocumentModel document, FileModel file) onSave;
  final LibraryDocumentModel? document;

  @override
  State<CreateOrUpdateLibraryDocumentDialog> createState() =>
      _CreateOrUpdateLibraryDocumentDialogState();
}

class _CreateOrUpdateLibraryDocumentDialogState extends State<CreateOrUpdateLibraryDocumentDialog> {
  late final _titleController = TextEditingController(text: widget.document?.title);
  late final _authorController = TextEditingController(text: widget.document?.author);
  late final _institutionController = TextEditingController(text: widget.document?.institution);
  late final _yearController = TextEditingController(text: widget.document?.year.toString());
  late final _documentUrlController = TextEditingController(text: widget.document?.documentUrl);
  final _file = ValueNotifier<FileModel?>(null);

  final _titleKey = GlobalKey<FormFieldState<String>>();
  final _authorKey = GlobalKey<FormFieldState<String>>();
  final _institutionKey = GlobalKey<FormFieldState<String>>();
  final _yearKey = GlobalKey<FormFieldState<String>>();
  final _typeKey = GlobalKey<FormFieldState<DocumentType>>();
  final _categoriesKey = GlobalKey<FormFieldState<List<DocumentCategory>>>();
  final _fileKey = GlobalKey<FormFieldState<FileModel>>();
  final _fileUrlKey = GlobalKey<FormFieldState<String>>();

  final _titleFocus = FocusNode();
  final _authorFocus = FocusNode();
  final _institutionFocus = FocusNode();
  final _yearFocus = FocusNode();
  final _typeFocus = FocusNode();
  final _categoriesFocus = FocusNode();
  final _fileFocus = FocusNode();
  final _fileUrlFocus = FocusNode();

  late DocumentType? _type = widget.document?.type;
  late List<DocumentCategory> _categories = [...?widget.document?.categories];

  bool get _isUpdate => widget.document != null;

  @override
  void dispose() {
    for (final controller in [
      _titleController,
      _authorController,
      _institutionController,
      _yearController,
      _documentUrlController,
    ]) {
      controller.dispose();
    }
    for (final node in [
      _titleFocus,
      _authorFocus,
      _institutionFocus,
      _yearFocus,
      _typeFocus,
      _categoriesFocus,
      _fileFocus,
      _fileUrlFocus,
    ]) {
      node.dispose();
    }
    _file.dispose();
    super.dispose();
  }

  Future<String?> _save() {
    final file = _file.value;
    final documentUrl = _documentUrlController.text;

    return widget.onSave(
      LibraryDocumentModel(
        id: widget.document?.id,
        area: widget.area,
        title: _titleController.text,
        author: _authorController.text,
        type: _type!,
        categories: _categories,
        institution: _institutionController.text,
        year: int.tryParse(_yearController.text) ?? 0,
        documentUrl: documentUrl,
        createdAt: widget.document?.createdAt ?? DateTime.now(),
      ),
      FileModel(
        url: documentUrl,
        bytes: file?.bytes,
        name: file?.name,
        extension: file?.extension,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: AppTheme.dimensions.components.formFieldGap);

    return PanelSheet(
      title: _isUpdate ? 'Editar documento' : 'Novo documento',
      onSave: _save,
      fields: [
        PanelSheetField(_titleKey, _titleFocus),
        PanelSheetField(_authorKey, _authorFocus),
        PanelSheetField(_institutionKey, _institutionFocus),
        PanelSheetField(_yearKey, _yearFocus),
        PanelSheetField(_typeKey, _typeFocus),
        PanelSheetField(_categoriesKey, _categoriesFocus),
        PanelSheetField(_fileKey, panelPickFocusTarget(_fileFocus, _fileUrlFocus)),
        PanelSheetField(_fileUrlKey, _fileUrlFocus),
      ],
      builder: (context) {
        void submit(String _) => PanelSheet.submitOf(context);

        FormTextField text(
          String label,
          TextEditingController controller,
          GlobalKey<FormFieldState<String>> key,
          FocusNode focusNode, {
          bool autofocus = false,
        }) {
          return FormTextField(
            label: label,
            controller: controller,
            focusNode: focusNode,
            formFieldKey: key,
            validator: PanelValidators.required,
            autofocus: autofocus,
            textInputAction: TextInputAction.done,
            onSubmitted: submit,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            text('Título', _titleController, _titleKey, _titleFocus, autofocus: true),
            gap,
            text('Autor', _authorController, _authorKey, _authorFocus),
            gap,
            text('Instituição', _institutionController, _institutionKey, _institutionFocus),
            gap,
            FormTextField(
              label: 'Ano',
              controller: _yearController,
              focusNode: _yearFocus,
              formFieldKey: _yearKey,
              validator: PanelValidators.required,
              hintText: 'AAAA',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.done,
              onSubmitted: submit,
            ),
            gap,
            PanelSelectField<DocumentType>(
              label: 'Tipo de produção',
              options: [
                const LibraryFilterOption(null, 'Escolha o tipo'),
                for (final type in [DocumentType.dissertacao, DocumentType.tese])
                  LibraryFilterOption(type, type.value),
              ],
              value: _type,
              formFieldKey: _typeKey,
              focusNode: _typeFocus,
              validator: PanelValidators.choice('Escolha o tipo de produção.'),
              onSelected: (type) => setState(() => _type = type),
            ),
            gap,
            PanelCheckGroup<DocumentCategory>(
              label: 'Categorias',
              boxed: true,
              options: [
                for (final category in DocumentCategory.values)
                  PanelCheckOption(category, category.value),
              ],
              selected: _categories,
              formFieldKey: _categoriesKey,
              focusNode: _categoriesFocus,
              validator: PanelValidators.choice('Marque pelo menos uma categoria.'),
              onChanged: (categories) => setState(() => _categories = categories),
            ),
            gap,
            PanelFileField(
              label: 'Arquivo',
              urlController: _documentUrlController,
              file: _file,
              formFieldKey: _fileKey,
              urlFieldKey: _fileUrlKey,
              focusNode: _fileFocus,
              urlFocusNode: _fileUrlFocus,
            ),
          ],
        );
      },
    );
  }
}
