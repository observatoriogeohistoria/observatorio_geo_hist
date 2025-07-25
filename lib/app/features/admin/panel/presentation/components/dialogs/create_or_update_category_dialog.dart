import 'dart:async';

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/switch_button.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_image_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/generator/id_generator.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/post_form_dialog.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

void showCreateOrUpdateCategoryDialog(
  BuildContext context, {
  required void Function(CategoryModel category) onCreateOrUpdate,
  CategoryModel? category,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => CreateOrUpdateCategoryDialog(
      onCreateOrUpdate: onCreateOrUpdate,
      category: category,
    ),
  );
}

class CreateOrUpdateCategoryDialog extends StatefulWidget {
  const CreateOrUpdateCategoryDialog({
    required this.onCreateOrUpdate,
    this.category,
    super.key,
  });

  final void Function(CategoryModel category) onCreateOrUpdate;
  final CategoryModel? category;

  @override
  State<CreateOrUpdateCategoryDialog> createState() => _CreateOrUpdateCategoryDialogState();
}

class _CreateOrUpdateCategoryDialogState extends State<CreateOrUpdateCategoryDialog> {
  final StreamController<Completer<FileModel?>> _imageController = StreamController();

  late final _keyController =
      TextEditingController(text: widget.category?.key ?? IdGenerator.generate());
  late final _titleController = TextEditingController(text: widget.category?.title);
  late final _descriptionController = TextEditingController(text: widget.category?.description);
  late final _imageUrlController = TextEditingController(text: widget.category?.backgroundImg.url);

  late bool isHistory = widget.category?.areas.contains(PostsAreas.history) ?? false;
  late bool isGeography = widget.category?.areas.contains(PostsAreas.geography) ?? false;
  late bool isCollaborate = widget.category?.hasCollaborateOption ?? false;

  bool get _isUpdate => widget.category != null;

  Future<FileModel?> _getImage() {
    final completer = Completer<FileModel?>();
    _imageController.add(completer);

    return completer.future;
  }

  @override
  void dispose() {
    _imageController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PostFormDialog(
      onSubmit: _onCreateOrUpdate,
      isUpdate: _isUpdate,
      isFullScreen: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTitle.medium(
            text: _isUpdate ? 'Atualizar categoria' : 'Criar categoria',
            color: AppTheme.colors.orange,
          ),
          SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
          AppTextField(
            controller: _keyController,
            labelText: 'Chave',
            validator: Validators.isNotEmpty,
            isDisabled: true,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _titleController,
            labelText: 'Título',
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _descriptionController,
            labelText: 'Descrição',
            validator: Validators.isNotEmpty,
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 5,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppImageField(
            imageUrlController: _imageUrlController,
            imageController: _imageController,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          SwitchButton(
            title: 'História',
            onChanged: (value) => setState(() => isHistory = value),
            initialValue: isHistory,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          SwitchButton(
            title: 'Geografia',
            onChanged: (value) => setState(() => isGeography = value),
            initialValue: isGeography,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          SwitchButton(
            title: 'Colaborar',
            onChanged: (value) => setState(() => isCollaborate = value),
            initialValue: isCollaborate,
          ),
        ],
      ),
    );
  }

  Future<void> _onCreateOrUpdate() async {
    FileModel? image = await _getImage();

    if ((image?.isNull ?? true) && _imageUrlController.text.isEmpty) {
      _showErrorMessage('Preencha a imagem do post');
      return;
    }

    final category = CategoryModel(
      key: _keyController.text,
      title: _titleController.text,
      description: _descriptionController.text,
      backgroundImg: FileModel(
        url: _imageUrlController.text,
        bytes: image?.bytes,
        name: image?.name,
      ),
      areas: [
        if (isHistory) PostsAreas.history,
        if (isGeography) PostsAreas.geography,
      ],
      hasCollaborateOption: isCollaborate,
    );

    widget.onCreateOrUpdate(category);
  }

  void _showErrorMessage(String message) {
    if (context.mounted) {
      Messenger.showError(context, message);
    }
  }
}
