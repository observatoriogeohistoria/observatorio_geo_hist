import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_dropdown_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/academic_production_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/form_dialog.dart';
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
  late final AcademicProductionModel? _initialBody = widget.post.body as AcademicProductionModel?;

  late final _titleController = TextEditingController(text: _initialBody?.title);
  late final _authorController = TextEditingController(text: _initialBody?.author);
  late final _advisorController = TextEditingController(text: _initialBody?.advisor);
  late final _imageController = TextEditingController(text: _initialBody?.image);
  late final _imageCaptionController = TextEditingController(text: _initialBody?.imageCaption);
  late final _institutionController = TextEditingController(text: _initialBody?.institution);
  late final _yearAndCityController = TextEditingController(text: _initialBody?.yearAndCity);
  late final _summaryController = TextEditingController(text: _initialBody?.summary);
  late final _keywordsController = TextEditingController(text: _initialBody?.keywords);
  late final _linkController = TextEditingController(text: _initialBody?.link);

  late AcademicProductionCategory? _selectedCategory = _initialBody?.category;

  bool get _isUpdate => widget.post.id != null;

  @override
  Widget build(BuildContext context) {
    return FormDialog(
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
          AppTextField(
            controller: _imageController,
            labelText: 'URL da imagem',
            hintText: 'https://',
            validator: Validators.isValidUrl,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _imageCaptionController,
            labelText: 'Legenda da imagem',
            validator: Validators.isNotEmpty,
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

  void _onCreateOrUpdate() {
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
          image: _imageController.text,
          imageCaption: _imageCaptionController.text,
          institution: _institutionController.text,
          yearAndCity: _yearAndCityController.text,
          summary: _summaryController.text,
          keywords: _keywordsController.text,
          link: _linkController.text,
        ),
      ),
    );
  }
}
