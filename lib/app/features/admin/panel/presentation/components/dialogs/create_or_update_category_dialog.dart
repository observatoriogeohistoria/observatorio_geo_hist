import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/switch_button.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/right_aligned_dialog.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/generator/id_generator.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
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
  final _formKey = GlobalKey<FormState>();

  late final _keyController =
      TextEditingController(text: widget.category?.key ?? IdGenerator.generate());
  late final _titleController = TextEditingController(text: widget.category?.title);
  late final _descriptionController = TextEditingController(text: widget.category?.description);
  late final _backgroundImgUrlController =
      TextEditingController(text: widget.category?.backgroundImgUrl);

  late bool isHistory = widget.category?.areas.contains(PostsAreas.history) ?? false;
  late bool isGeography = widget.category?.areas.contains(PostsAreas.geography) ?? false;

  bool get _isUpdate => widget.category != null;

  @override
  Widget build(BuildContext context) {
    return RightAlignedDialog(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
            AppTextField(
              controller: _backgroundImgUrlController,
              labelText: 'URL da imagem de fundo',
              validator: Validators.isNotEmpty,
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
            const Spacer(),
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
    );
  }

  void _onCreateOrUpdate() {
    if (!_formKey.currentState!.validate()) return;

    final category = CategoryModel(
      key: _keyController.text,
      title: _titleController.text,
      description: _descriptionController.text,
      backgroundImgUrl: _backgroundImgUrlController.text,
      areas: [
        if (isHistory) PostsAreas.history,
        if (isGeography) PostsAreas.geography,
      ],
    );

    widget.onCreateOrUpdate(category);
  }
}
