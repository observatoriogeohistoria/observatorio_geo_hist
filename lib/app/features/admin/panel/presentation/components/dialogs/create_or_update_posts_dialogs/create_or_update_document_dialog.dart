import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/right_aligned_dialog.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_dropdown_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/quill/editor_quill.dart';
import 'package:observatorio_geo_hist/app/core/components/scroll/app_scrollbar.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/document_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

void showCreateOrUpdateDocumentDialog(
  BuildContext context, {
  required void Function(PostModel post) onCreateOrUpdate,
  required PostModel post,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => CreateOrUpdateDocumentDialog(
      onCreateOrUpdate: onCreateOrUpdate,
      post: post,
    ),
  );
}

class CreateOrUpdateDocumentDialog extends StatefulWidget {
  const CreateOrUpdateDocumentDialog({
    required this.onCreateOrUpdate,
    required this.post,
    super.key,
  });

  final void Function(PostModel post) onCreateOrUpdate;
  final PostModel post;

  @override
  State<CreateOrUpdateDocumentDialog> createState() => _CreateOrUpdateDocumentDialogState();
}

class _CreateOrUpdateDocumentDialogState extends State<CreateOrUpdateDocumentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  final _descriptionController = StreamController<Completer<String>>();

  late final DocumentModel? _initialBody = widget.post.body as DocumentModel?;

  late final _titleController = TextEditingController(text: _initialBody?.title);
  late final _imageController = TextEditingController(text: _initialBody?.image);
  late final _linkController = TextEditingController(text: _initialBody?.link);

  late final String? _initialDescription = _initialBody?.description;

  late DocumentCategory? _selectedCategory = _initialBody?.category;

  bool get _isUpdate => widget.post.id != null;

  @override
  void dispose() {
    _descriptionController.close();
    super.dispose();
  }

  Future<String> _getDescription() {
    final completer = Completer<String>();
    _descriptionController.add(completer);
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return RightAlignedDialog(
      width: MediaQuery.of(context).size.width,
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: AppScrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTitle.medium(
                  text: _isUpdate ? 'Atualizar documento' : 'Criar documento',
                  color: AppTheme.colors.orange,
                ),
                SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
                AppDropdownField<DocumentCategory>(
                  hintText: 'Categoria',
                  items: DocumentCategory.values,
                  itemToString: (value) => value.portuguese,
                  value: _selectedCategory,
                  onChanged: (value) {
                    if (value == null) return;

                    DocumentCategory? selected = DocumentCategory.fromPortuguese(value);
                    setState(() => _selectedCategory = selected);
                  },
                  validator: Validators.isNotEmpty,
                ),
                SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                AppTextField(
                  controller: _titleController,
                  labelText: 'Título',
                  validator: Validators.isNotEmpty,
                ),
                SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                AppTextField(
                  controller: _imageController,
                  labelText: 'URL da imagem',
                  hintText: 'https://',
                  validator: Validators.isValidUrl,
                ),
                SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                EditorQuill(
                  saveController: _descriptionController,
                  initialContent: _initialDescription,
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
                SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                AppTextField(
                  controller: _linkController,
                  labelText: 'Link',
                  hintText: 'https://',
                  validator: Validators.isValidUrl,
                ),
                SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SecondaryButton.medium(
                      text: 'Cancelar',
                      onPressed: () => GoRouter.of(context).pop(),
                    ),
                    SizedBox(width: AppTheme.dimensions.space.medium.horizontalSpacing),
                    PrimaryButton.medium(
                      text: _isUpdate ? 'Atualizar' : 'Criar',
                      onPressed: _onCreateOrUpdate,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onCreateOrUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    final description = await _getDescription();

    widget.onCreateOrUpdate(
      widget.post.copyWith(
        id: widget.post.id,
        type: PostType.document,
        createdAt: widget.post.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        isPublished: widget.post.isPublished,
        isHighlighted: widget.post.isHighlighted,
        body: DocumentModel(
          category: _selectedCategory!,
          title: _titleController.text,
          image: _imageController.text,
          description: description,
          link: _linkController.text,
        ),
      ),
    );
  }
}
