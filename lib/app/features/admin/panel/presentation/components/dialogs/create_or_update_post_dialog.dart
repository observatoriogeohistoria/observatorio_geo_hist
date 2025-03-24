import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/right_aligned_dialog.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_dropdown_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/markdown/markdown_text.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_label.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/formatters/mont_year_input_formatter.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

void showCreateOrUpdatePostDialog(
  BuildContext context, {
  required List<CategoryModel> categories,
  required void Function(PostModel post) onCreateOrUpdate,
  PostModel? post,
}) {
  showDialog(
    context: context,
    builder: (_) => CreateOrUpdatePostDialog(
      categories: categories,
      onCreateOrUpdate: onCreateOrUpdate,
      post: post,
    ),
  );
}

class CreateOrUpdatePostDialog extends StatefulWidget {
  const CreateOrUpdatePostDialog({
    required this.categories,
    required this.onCreateOrUpdate,
    this.post,
    super.key,
  });

  final List<CategoryModel> categories;
  final void Function(PostModel post) onCreateOrUpdate;
  final PostModel? post;

  @override
  State<CreateOrUpdatePostDialog> createState() => _CreateOrUpdatePostDialogState();
}

class _CreateOrUpdatePostDialogState extends State<CreateOrUpdatePostDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _titleController = TextEditingController(text: widget.post?.title);
  late final _subtitleController = TextEditingController(text: widget.post?.subtitle);
  late final _contentController = TextEditingController(text: widget.post?.markdownContent);
  late final _imageUrlController = TextEditingController(text: widget.post?.imgUrl);
  late final _dateController = TextEditingController(text: widget.post?.date);

  late PostsAreas? _selectedArea = widget.post?.area;
  late CategoryModel? _selectedCategory = widget.post?.category;

  late List<CategoryModel> _categoryOptions =
      widget.categories.where((category) => category.area.key == _selectedArea?.key).toList();

  late final List<TextEditingController> _authorsControllers =
      widget.post?.authors.map((author) => TextEditingController(text: author)).toList() ??
          [TextEditingController()];

  bool get _isUpdate => widget.post != null;

  @override
  Widget build(BuildContext context) {
    return RightAlignedDialog(
      width: MediaQuery.of(context).size.width,
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTitle.medium(
                text: _isUpdate ? 'Atualizar post' : 'Criar post',
                color: AppTheme.colors.orange,
              ),
              SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 28),
                            AppTextField(
                              controller: _titleController,
                              labelText: 'Título',
                              validator: Validators.isNotEmpty,
                            ),
                            SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                            AppTextField(
                              controller: _subtitleController,
                              labelText: 'Subtítulo',
                              validator: Validators.isNotEmpty,
                            ),
                            SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                            AppTextField(
                              controller: _imageUrlController,
                              labelText: 'URL da imagem',
                              hintText: 'https://',
                              validator: Validators.isNotEmpty,
                            ),
                            SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
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
                            SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
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

                                  _selectedCategory = null;
                                  _categoryOptions = widget.categories
                                      .where((category) => category.area.key == _selectedArea!.key)
                                      .toList();
                                });
                              },
                              validator: Validators.isNotEmpty,
                            ),
                            SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                            _buildLabel('Categoria'),
                            AppDropdownField<CategoryModel>(
                              hintText: 'Selecione',
                              items: _categoryOptions,
                              itemToString: (category) => category.title,
                              value: _selectedCategory,
                              onChanged: (category) {
                                if (category == null) return;

                                CategoryModel? selectedCategory = widget.categories
                                    .firstWhereOrNull((value) =>
                                        value.title == category && value.area == _selectedArea);
                                if (selectedCategory == null) return;

                                setState(() => _selectedCategory = selectedCategory);
                              },
                              validator: Validators.isNotEmpty,
                            ),
                            SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                            _buildLabel('Autores'),
                            for (var i = 0; i < _authorsControllers.length; i++)
                              Column(
                                children: [
                                  AppTextField(
                                    controller: _authorsControllers[i],
                                    validator: Validators.isNotEmpty,
                                  ),
                                  SizedBox(
                                    height: AppTheme.dimensions.space.mini.verticalSpacing,
                                  ),
                                ],
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () => setState(
                                      () => _authorsControllers.add(TextEditingController())),
                                  icon: Icon(Icons.add, color: AppTheme.colors.orange),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (_authorsControllers.length == 1) return;
                                    setState(() => _authorsControllers.removeLast());
                                  },
                                  icon: Icon(Icons.remove, color: AppTheme.colors.orange),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: AppTheme.dimensions.space.medium.horizontalSpacing),
                    Expanded(
                      flex: 2,
                      child: SingleChildScrollView(
                        child: Row(
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Conteúdo em Markdown'),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.7,
                                    child: AppTextField(
                                      controller: _contentController,
                                      validator: Validators.isNotEmpty,
                                      keyboardType: TextInputType.multiline,
                                      minLines: null,
                                      maxLines: null,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: AppTheme.dimensions.space.medium.horizontalSpacing),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Preview do Conteúdo'),
                                  Container(
                                    height: MediaQuery.of(context).size.height * 0.7,
                                    padding: EdgeInsets.all(AppTheme.dimensions.space.small.scale),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppTheme.colors.orange,
                                        width: AppTheme.dimensions.stroke.small,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(AppTheme.dimensions.radius.medium),
                                    ),
                                    child: SingleChildScrollView(
                                      child: MarkdownText(
                                        text: _contentController.text,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
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
    );
  }

  Widget _buildLabel(String text) {
    return Column(
      children: [
        AppLabel.medium(
          text: text,
          color: AppTheme.colors.darkGray,
        ),
        SizedBox(height: AppTheme.dimensions.space.mini.verticalSpacing),
      ],
    );
  }

  void _onCreateOrUpdate() {
    if (!_formKey.currentState!.validate()) return;

    widget.onCreateOrUpdate(
      PostModel(
        id: widget.post?.id,
        title: _titleController.text,
        subtitle: _subtitleController.text,
        area: _selectedArea!,
        category: _selectedCategory!,
        markdownContent: _contentController.text,
        date: _dateController.text,
        imgUrl: _imageUrlController.text,
        authors: _authorsControllers.map((controller) => controller.text).toList(),
      ),
    );

    GoRouter.of(context).pop();
  }
}
