import 'dart:async';

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_dropdown_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_image_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/quill/editor_quill.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/document_model.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/form_dialog.dart';
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
  final StreamController<Completer<String>> _descriptionController = StreamController();
  final StreamController<Completer<ImageModel?>> _imageController = StreamController();

  late final DocumentModel? _initialBody = widget.post.body as DocumentModel?;

  late final _titleController = TextEditingController(text: _initialBody?.title);
  late final _imageUrlController = TextEditingController(text: _initialBody?.image.url);
  late final _linkController = TextEditingController(text: _initialBody?.link);

  late final String? _initialDescription = _initialBody?.description;

  late DocumentCategory? _selectedCategory = _initialBody?.category;

  bool get _isUpdate => widget.post.id != null;

  Future<String> _getDescription() {
    final completer = Completer<String>();
    _descriptionController.add(completer);

    return completer.future;
  }

  Future<ImageModel?> _getImage() {
    final completer = Completer<ImageModel?>();
    _imageController.add(completer);

    return completer.future;
  }

  @override
  void dispose() {
    _descriptionController.close();
    _imageController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormDialog(
      onSubmit: _onCreateOrUpdate,
      isUpdate: _isUpdate,
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
          AppImageField(
            imageUrlController: _imageUrlController,
            imageController: _imageController,
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
        ],
      ),
    );
  }

  Future<void> _onCreateOrUpdate() async {
    String description = await _getDescription();
    ImageModel? image = await _getImage();

    if (description.isEmpty) {
      _showErrorMessage('Preencha a descrição do post');
      return;
    }

    if ((image?.isNull ?? true) && _imageUrlController.text.isEmpty) {
      _showErrorMessage('Preencha a imagem do post');
      return;
    }

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
          image: ImageModel(
            url: _imageUrlController.text,
            bytes: image?.bytes,
            name: image?.name,
          ),
          description: description,
          link: _linkController.text,
        ),
      ),
    );
  }

  void _showErrorMessage(String message) {
    if (context.mounted) {
      Messenger.showError(context, message);
    }
  }
}
