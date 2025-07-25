import 'dart:async';

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_dropdown_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_image_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/academic_production_model.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/post_form_dialog.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

void showCreateOrUpdateAcademicProductionDialog(
  BuildContext context, {
  required void Function(PostModel post) onCreateOrUpdate,
  required PostModel post,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => CreateOrUpdateAcademicProductionDialog(
      onCreateOrUpdate: onCreateOrUpdate,
      post: post,
    ),
  );
}

class CreateOrUpdateAcademicProductionDialog extends StatefulWidget {
  const CreateOrUpdateAcademicProductionDialog({
    required this.onCreateOrUpdate,
    required this.post,
    super.key,
  });

  final void Function(PostModel post) onCreateOrUpdate;
  final PostModel post;

  @override
  State<CreateOrUpdateAcademicProductionDialog> createState() =>
      _CreateOrUpdateAcademicProductionDialogState();
}

class _CreateOrUpdateAcademicProductionDialogState
    extends State<CreateOrUpdateAcademicProductionDialog> {
  final StreamController<Completer<FileModel?>> _imageController = StreamController();

  late final AcademicProductionModel? _initialBody = widget.post.body as AcademicProductionModel?;

  late final _titleController = TextEditingController(text: _initialBody?.title);
  late final _authorController = TextEditingController(text: _initialBody?.author);
  late final _advisorController = TextEditingController(text: _initialBody?.advisor);
  late final _imageUrlController = TextEditingController(text: _initialBody?.image.url);
  late final _institutionController = TextEditingController(text: _initialBody?.institution);
  late final _yearAndCityController = TextEditingController(text: _initialBody?.yearAndCity);
  late final _summaryController = TextEditingController(text: _initialBody?.summary);
  late final _keywordsController = TextEditingController(text: _initialBody?.keywords);
  late final _linkController = TextEditingController(text: _initialBody?.link);

  late AcademicProductionCategory? _selectedCategory = _initialBody?.category;

  bool get _isUpdate => widget.post.id != null;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTitle.medium(
            text: _isUpdate ? 'Atualizar produção acadêmica' : 'Criar produção acadêmica',
            color: AppTheme.colors.orange,
          ),
          SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
          AppTextField(
            controller: _titleController,
            labelText: 'Título',
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppDropdownField<AcademicProductionCategory>(
            hintText: 'Categoria',
            items: AcademicProductionCategory.values,
            itemToString: (value) => value.portuguese,
            value: _selectedCategory,
            onChanged: (value) {
              if (value == null) return;

              AcademicProductionCategory? selected =
                  AcademicProductionCategory.fromPortuguese(value);
              setState(() => _selectedCategory = selected);
            },
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _authorController,
            labelText: 'Autor',
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _advisorController,
            labelText: 'Orientador',
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppImageField(
            imageUrlController: _imageUrlController,
            imageController: _imageController,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _institutionController,
            labelText: 'Instituição',
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _yearAndCityController,
            labelText: 'Cidade e ano de publicação',
            hintText: 'Ex: São Paulo, 2021',
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _summaryController,
            labelText: 'Resumo',
            validator: Validators.isNotEmpty,
            minLines: 6,
            maxLines: 6,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _keywordsController,
            labelText: 'Palavras-chave',
            hintText: 'Separe com vírgulas',
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _linkController,
            labelText: 'Link da pesquisa',
            hintText: 'https://',
            validator: Validators.isValidUrl,
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

    widget.onCreateOrUpdate(
      widget.post.copyWith(
        id: widget.post.id,
        type: PostType.academicProduction,
        createdAt: widget.post.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        isPublished: widget.post.isPublished,
        isHighlighted: widget.post.isHighlighted,
        body: AcademicProductionModel(
          title: _titleController.text,
          category: _selectedCategory!,
          author: _authorController.text,
          advisor: _advisorController.text,
          image: FileModel(
            url: _imageUrlController.text,
            bytes: image?.bytes,
            name: image?.name,
          ),
          institution: _institutionController.text,
          yearAndCity: _yearAndCityController.text,
          summary: _summaryController.text,
          keywords: _keywordsController.text,
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
