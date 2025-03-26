import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/switch_button.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/right_aligned_dialog.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_dropdown_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/quill/editor_quill.dart';
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
    barrierDismissible: false,
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

  final StreamController<Completer<String>> _contentController = StreamController();
  final StreamController<Completer<String>> _observationController = StreamController();

  late final String? _initialContent = widget.post?.markdownContent;
  late final String? _initialObservation = widget.post?.observation;

  late final _titleController = TextEditingController(text: widget.post?.title);
  late final _subtitleController = TextEditingController(text: widget.post?.subtitle);
  late final _imageUrlController = TextEditingController(text: widget.post?.imgUrl);
  late final _dateController = TextEditingController(text: widget.post?.date);
  late final _imageCaptionController = TextEditingController(text: widget.post?.imgCaption);

  late bool isHistory = widget.post?.areas.contains(PostsAreas.history) ?? false;
  late bool isGeography = widget.post?.areas.contains(PostsAreas.geography) ?? false;

  late CategoryModel? _selectedCategory = widget.post?.category;

  late final List<TextEditingController> _authorsControllers =
      widget.post?.authors.map((author) => TextEditingController(text: author)).toList() ??
          [TextEditingController()];

  List<CategoryModel> get _categoryOptions {
    List<CategoryModel> categories = [];

    for (var category in widget.categories) {
      if (isHistory && category.areas.contains(PostsAreas.history)) {
        categories.add(category);
      } else if (isGeography && category.areas.contains(PostsAreas.geography)) {
        categories.add(category);
      }
    }

    return categories;
  }

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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTitle.medium(
                  text: _isUpdate ? 'Atualizar post' : 'Criar post',
                  color: AppTheme.colors.orange,
                ),
                SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
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
                  controller: _imageCaptionController,
                  labelText: 'Legenda da imagem',
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
                SwitchButton(
                  title: 'História',
                  onChanged: (value) => setState(() => isHistory = value),
                  initialValue: isHistory,
                ),
                SwitchButton(
                  title: 'Geografia',
                  onChanged: (value) => setState(() => isGeography = value),
                  initialValue: isGeography,
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

                    CategoryModel? selectedCategory =
                        widget.categories.firstWhereOrNull((value) => value.title == category);
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
                SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () =>
                          setState(() => _authorsControllers.add(TextEditingController())),
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
                SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                _buildLabel('Conteúdo'),
                EditorQuill(
                  saveController: _contentController,
                  initialContent: _initialContent,
                  height: MediaQuery.of(context).size.height * 0.7,
                ),
                SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                _buildLabel('Observação'),
                EditorQuill(
                  saveController: _observationController,
                  initialContent: _initialObservation,
                  height: MediaQuery.of(context).size.height * 0.4,
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

  Future<String> _getContent() async {
    final complete = Completer<String>();
    _contentController.add(complete);

    return await complete.future;
  }

  Future<String> _getObservation() {
    final complete = Completer<String>();
    _observationController.add(complete);

    return complete.future;
  }

  Future<void> _onCreateOrUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    String content = await _getContent();
    String observation = await _getObservation();

    widget.onCreateOrUpdate(
      PostModel(
        title: _titleController.text,
        subtitle: _subtitleController.text,
        areas: [
          if (isHistory) PostsAreas.history,
          if (isGeography) PostsAreas.geography,
        ],
        categoryKey: _selectedCategory!.key,
        markdownContent: content,
        date: _dateController.text,
        imgUrl: _imageUrlController.text,
        authors: _authorsControllers.map((controller) => controller.text).toList(),
        id: widget.post?.id,
        category: _selectedCategory!,
        imgCaption: _imageCaptionController.text,
        observation: observation,
        createdAt: widget.post?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        isPublished: widget.post?.isPublished ?? false,
        isHighlighted: widget.post?.isHighlighted ?? false,
      ),
    );
  }
}
