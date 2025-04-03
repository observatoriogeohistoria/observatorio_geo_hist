import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/switch_button.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/right_aligned_dialog.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_dropdown_field.dart';
import 'package:observatorio_geo_hist/app/core/components/scroll/app_scrollbar.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_or_update_posts_dialogs/create_or_update_article_dialog.dart';
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
  final _scrollController = ScrollController();

  bool get isMobile => DeviceUtils.isMobile(context);

  List<PostType> types = PostType.values.toList();

  late bool isHistory = widget.post?.areas.contains(PostsAreas.history) ?? false;
  late bool isGeography = widget.post?.areas.contains(PostsAreas.geography) ?? false;

  late CategoryModel? _selectedCategory = widget.post?.category;
  late PostType? _selectedType = widget.post?.type;

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
  void initState() {
    super.initState();
    types.sort((a, b) => a.portuguese.compareTo(b.portuguese));
  }

  @override
  Widget build(BuildContext context) {
    return RightAlignedDialog(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double padding = AppTheme.dimensions.space.medium.horizontalSpacing;
          double width = isMobile ? constraints.maxWidth : (constraints.maxWidth / 2) - padding;

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: padding),
              SizedBox(
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTitle.big(
                      text: 'Área',
                      color: AppTheme.colors.orange,
                    ),
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
                    AppTitle.big(
                      text: 'Categoria',
                      color: AppTheme.colors.orange,
                    ),
                    SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                    AppDropdownField<CategoryModel>(
                      hintText: 'Selecione',
                      items: _categoryOptions,
                      itemToString: (category) => category.title,
                      value: _selectedCategory,
                      onChanged: (category) {
                        if (category == null) return;

                        CategoryModel? selectedCategory =
                            widget.categories.firstWhereOrNull((value) => value.title == category);

                        setState(() => _selectedCategory = selectedCategory);
                      },
                      validator: Validators.isNotEmpty,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
              Expanded(
                child: AppScrollbar(
                  controller: _scrollController,
                  child: AlignedGridView.count(
                    controller: _scrollController,
                    crossAxisCount: isMobile ? 1 : 2,
                    mainAxisSpacing: AppTheme.dimensions.space.medium.verticalSpacing,
                    crossAxisSpacing: AppTheme.dimensions.space.medium.horizontalSpacing,
                    itemCount: types.length,
                    itemBuilder: (context, index) {
                      final type = types[index];
                      final isSelected = type == _selectedType;

                      return SizedBox(
                        width: width,
                        child: isSelected
                            ? PrimaryButton.big(
                                text: type.portuguese,
                                onPressed: () => setState(() => _selectedType = type),
                                isDisabled: _isUpdate,
                              )
                            : SecondaryButton.big(
                                text: type.portuguese,
                                onPressed: () => setState(() => _selectedType = type),
                                isDisabled: _isUpdate,
                              ),
                      );
                    },
                  ),
                ),
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
                    text: 'Avançar',
                    onPressed: _onTap,
                    isDisabled: _selectedCategory == null || _selectedType == null,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _onTap() {
    GoRouter.of(context).pop();

    if (_selectedType == PostType.article) {
      showCreateOrUpdateArticleDialog(
        context,
        onCreateOrUpdate: widget.onCreateOrUpdate,
        post: PostModel(
          categoryId: _selectedCategory!.key,
          category: _selectedCategory!,
          areas: [
            if (isHistory) PostsAreas.history,
            if (isGeography) PostsAreas.geography,
          ],
          type: _selectedType!,
        ),
      );
    }
  }
}
