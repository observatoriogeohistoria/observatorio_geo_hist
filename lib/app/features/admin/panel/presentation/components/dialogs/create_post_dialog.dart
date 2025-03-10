import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/right_aligned_dialog.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_dropdown_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_label.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/formatters/mont_year_input_formatter.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

void showCreatePostDialog(
  BuildContext context, {
  required List<CategoryModel> categories,
  required void Function(PostModel post) onCreate,
}) {
  showDialog(
    context: context,
    builder: (_) => CreatePostDialog(
      categories: categories,
      onCreate: onCreate,
    ),
  );
}

class CreatePostDialog extends StatefulWidget {
  const CreatePostDialog({
    required this.categories,
    required this.onCreate,
    super.key,
  });

  final List<CategoryModel> categories;
  final void Function(PostModel post) onCreate;

  @override
  State<CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _dateController = TextEditingController();

  PostsAreas? _selectedArea;
  CategoryModel? _selectedCategory;

  List<CategoryModel> _categoryOptions = [];
  final List<TextEditingController> _authorsControllers = [TextEditingController()];

  @override
  Widget build(BuildContext context) {
    return RightAlignedDialog(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTitle.medium(
                text: 'Criar post',
                color: AppTheme(context).colors.orange,
              ),
              SizedBox(height: AppTheme(context).dimensions.space.xlarge),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        controller: _titleController,
                        labelText: 'Título',
                        validator: Validators.isNotEmpty,
                      ),
                      SizedBox(height: AppTheme(context).dimensions.space.medium),
                      AppTextField(
                        controller: _subtitleController,
                        labelText: 'Subtítulo',
                        validator: Validators.isNotEmpty,
                      ),
                      SizedBox(height: AppTheme(context).dimensions.space.medium),
                      AppTextField(
                        controller: _contentController,
                        labelText: 'Conteúdo em Markdown',
                        validator: Validators.isNotEmpty,
                      ),
                      SizedBox(height: AppTheme(context).dimensions.space.medium),
                      AppTextField(
                        controller: _imageUrlController,
                        labelText: 'URL da imagem',
                        hintText: 'https://',
                      ),
                      SizedBox(height: AppTheme(context).dimensions.space.medium),
                      AppTextField(
                        controller: _dateController,
                        labelText: 'Data',
                        hintText: 'MM/yyyy',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                          MonthYearInputFormatter(),
                        ],
                        validator: Validators.isValidMonthAndYear,
                      ),
                      SizedBox(height: AppTheme(context).dimensions.space.medium),
                      _buildLabel('Área'),
                      AppDropdownField<PostsAreas>(
                        hintText: 'Selecione',
                        items: PostsAreas.values,
                        itemToString: (area) => area.name,
                        value: _selectedArea,
                        onChanged: (area) {
                          if (area == null) return;
                          setState(() {
                            _selectedArea = PostsAreas.fromName(area);
                            if (_selectedArea == null) return;

                            _categoryOptions = widget.categories
                                .where((category) => category.area.key == _selectedArea!.key)
                                .toList();
                          });
                        },
                        validator: Validators.isNotEmpty,
                      ),
                      SizedBox(height: AppTheme(context).dimensions.space.medium),
                      _buildLabel('Categoria'),
                      AppDropdownField<CategoryModel>(
                        hintText: 'Selecione',
                        items: _categoryOptions,
                        itemToString: (category) => category.title,
                        value: _selectedCategory,
                        onChanged: (category) {
                          if (category == null) return;

                          CategoryModel? selectedCategory = widget.categories.firstWhereOrNull(
                              (value) => value.title == category && value.area == _selectedArea);
                          if (selectedCategory == null) return;

                          setState(() => _selectedCategory = selectedCategory);
                        },
                        validator: Validators.isNotEmpty,
                      ),
                      SizedBox(height: AppTheme(context).dimensions.space.medium),
                      _buildLabel('Autores'),
                      for (var i = 0; i < _authorsControllers.length; i++)
                        Column(
                          children: [
                            AppTextField(
                              controller: _authorsControllers[i],
                              labelText: 'Autor ${i + 1}',
                              validator: Validators.isNotEmpty,
                            ),
                            SizedBox(height: AppTheme(context).dimensions.space.xsmall),
                          ],
                        ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            setState(() => _authorsControllers.add(TextEditingController()));
                          },
                          icon: Icon(
                            Icons.add,
                            color: AppTheme(context).colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppTheme(context).dimensions.space.medium),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SecondaryButton.medium(
                    text: 'Cancelar',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(width: AppTheme(context).dimensions.space.medium),
                  PrimaryButton.medium(
                    text: 'Criar',
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;

                      widget.onCreate(
                        PostModel(
                          title: _titleController.text,
                          subtitle: _subtitleController.text,
                          area: _selectedArea!,
                          category: _selectedCategory!.key,
                          markdownContent: _contentController.text,
                          date: _dateController.text,
                          imgUrl: '',
                          authors:
                              _authorsControllers.map((controller) => controller.text).toList(),
                        ),
                      );

                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Column(
      children: [
        AppLabel.medium(
          text: text,
          color: AppTheme(context).colors.darkGray,
        ),
        SizedBox(height: AppTheme(context).dimensions.space.xsmall),
      ],
    );
  }
}
