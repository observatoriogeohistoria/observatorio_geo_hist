import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/right_aligned_dialog.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_document_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_multiselect_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/scroll/app_scrollbar.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/models/states/crud_states.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/panel_dialog_title.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/form_label.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/library_setup.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/stores/library_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

void showCreateOrUpdateLibraryDocumentDialog(
  BuildContext context, {
  required DocumentArea area,
  required void Function(LibraryDocumentModel document, FileModel? file) onCreateOrUpdate,
  LibraryDocumentModel? document,
  bool isLoading = false,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => CreateOrUpdateLibraryDocumentDialog(
      area: area,
      onCreateOrUpdate: onCreateOrUpdate,
      document: document,
    ),
  );
}

class CreateOrUpdateLibraryDocumentDialog extends StatefulWidget {
  const CreateOrUpdateLibraryDocumentDialog({
    required this.area,
    required this.onCreateOrUpdate,
    this.document,
    super.key,
  });

  final DocumentArea area;
  final void Function(LibraryDocumentModel document, FileModel? file) onCreateOrUpdate;
  final LibraryDocumentModel? document;

  @override
  State<CreateOrUpdateLibraryDocumentDialog> createState() =>
      _CreateOrUpdateLibraryDocumentDialogState();
}

class _CreateOrUpdateLibraryDocumentDialogState extends State<CreateOrUpdateLibraryDocumentDialog> {
  late final _libraryStore = LibrarySetup.getIt<LibraryStore>();

  final StreamController<Completer<FileModel?>> _documentController = StreamController();

  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  late final TextEditingController _titleController =
      TextEditingController(text: widget.document?.title);
  late final TextEditingController _authorController =
      TextEditingController(text: widget.document?.author);
  late final TextEditingController _institutionController =
      TextEditingController(text: widget.document?.institution);
  late final TextEditingController _yearController =
      TextEditingController(text: widget.document?.year.toString());
  late final TextEditingController _documentUrlController =
      TextEditingController(text: widget.document?.documentUrl);

  late DocumentType? _selectedType = widget.document?.type;
  late List<DocumentCategory> _selectedCategories = widget.document?.categories ?? [];

  bool get _isUpdate => widget.document != null;

  Future<FileModel?> _getDocument() {
    final completer = Completer<FileModel?>();
    _documentController.add(completer);

    return completer.future;
  }

  @override
  void dispose() {
    _documentController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ScreenUtils.isMobile(context);
    final spacing = AppTheme.dimensions.spacing;
    final space = SizedBox(height: spacing.s16);

    return Observer(
      builder: (context) {
        bool isLoading = _libraryStore.manageState is CrudLoadingState;

        return RightAlignedDialog(
          width: isMobile ? MediaQuery.of(context).size.width : null,
          child: Column(
            children: [
              Expanded(
                child: AppScrollbar(
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PanelDialogTitle(
                            text: _isUpdate ? 'Atualizar documento' : 'Criar documento',
                          ),
                          SizedBox(height: spacing.s32),
                          const FormLabel(text: 'Título'),
                          AppTextField(
                            controller: _titleController,
                            hintText: 'Título',
                            validator: Validators.isNotEmpty,
                          ),
                          space,
                          const FormLabel(text: 'Autor'),
                          AppTextField(
                            controller: _authorController,
                            hintText: 'Autor',
                            validator: Validators.isNotEmpty,
                          ),
                          space,
                          const FormLabel(text: 'Instituição'),
                          AppTextField(
                            controller: _institutionController,
                            hintText: 'Instituição',
                            validator: Validators.isNotEmpty,
                          ),
                          space,
                          const FormLabel(text: 'Ano'),
                          AppTextField(
                            controller: _yearController,
                            hintText: 'Ano',
                            validator: Validators.isNotEmpty,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                          space,
                          const FormLabel(text: 'Documento'),
                          AppDocumentField(
                            documentUrlController: _documentUrlController,
                            documentController: _documentController,
                          ),
                          space,
                          const FormLabel(text: 'Tipo de Produção'),
                          AppMultiSelectField<DocumentType>(
                            items: DocumentType.values,
                            itemToString: (item) => item.value,
                            selectedItems: _selectedType != null ? [_selectedType!] : [],
                            onChanged: (types) {
                              setState(() => _selectedType = types.isEmpty ? null : types.first);
                            },
                            isSingleSelect: true,
                          ),
                          space,
                          const FormLabel(text: 'Categorias'),
                          AppMultiSelectField<DocumentCategory>(
                            items: DocumentCategory.values,
                            itemToString: (item) => item.value,
                            selectedItems: _selectedCategories,
                            onChanged: (categories) {
                              setState(() => _selectedCategories = categories);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(top: spacing.s24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (!isLoading) ...[
                        SecondaryButton.medium(
                          text: 'Cancelar',
                          onPressed: () => GoRouter.of(context).pop(),
                        ),
                        SizedBox(width: spacing.s16),
                      ],
                      PrimaryButton.medium(
                        text: isLoading ? 'Aguarde...' : (_isUpdate ? 'Atualizar' : 'Criar'),
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;
                          _onSubmit();
                        },
                        isDisabled: isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onSubmit() async {
    if (_selectedType == null) {
      _showErrorMessage('Selecione o tipo de produção');
      return;
    }

    if (_selectedCategories.isEmpty) {
      _showErrorMessage('Selecione as categorias');
      return;
    }

    FileModel? file = await _getDocument();

    if ((file?.isNull ?? true) && _documentUrlController.text.isEmpty) {
      _showErrorMessage('Preencha o arquivo do documento');
      return;
    }

    LibraryDocumentModel document = LibraryDocumentModel(
      id: widget.document?.id,
      area: widget.area,
      title: _titleController.text,
      author: _authorController.text,
      type: _selectedType!,
      categories: _selectedCategories,
      institution: _institutionController.text,
      year: int.tryParse(_yearController.text) ?? 0,
      documentUrl: _documentUrlController.text,
      createdAt: widget.document?.createdAt ?? DateTime.now(),
    );

    FileModel fileModel = FileModel(
      url: _documentUrlController.text,
      bytes: file?.bytes,
      name: file?.name,
      extension: file?.extension,
    );

    widget.onCreateOrUpdate(document, fileModel);
  }

  void _showErrorMessage(String message) {
    if (context.mounted) {
      Messenger.showError(context, message);
    }
  }
}
