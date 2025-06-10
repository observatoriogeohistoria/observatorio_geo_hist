import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_dropdown_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class SectionHeaderActions extends StatelessWidget {
  const SectionHeaderActions({
    required this.onTextChange,
    required this.onAreaChange,
    required this.onCategoryChange,
    required this.onClear,
    required this.categories,
    required this.selectedText,
    required this.selectedArea,
    required this.selectedCategory,
    super.key,
  });

  final void Function(String text) onTextChange;
  final void Function(PostsAreas area) onAreaChange;
  final void Function(CategoryModel category) onCategoryChange;
  final void Function() onClear;

  final List<CategoryModel> categories;

  final String? selectedText;
  final PostsAreas? selectedArea;
  final CategoryModel? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final isMobile = DeviceUtils.isMobile(context);

    return Padding(
      padding: EdgeInsets.only(
        right: AppTheme.dimensions.space.medium.horizontalSpacing,
      ),
      child: Builder(
        builder: (context) {
          if (isMobile) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _textField,
                SizedBox(height: AppTheme.dimensions.space.mini.verticalSpacing),
                _areaField,
                SizedBox(height: AppTheme.dimensions.space.mini.verticalSpacing),
                _categoryField,
                SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                SecondaryButton.small(
                  text: 'Limpar filtros',
                  onPressed: onClear,
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    flex: 2,
                    child: _textField,
                  ),
                ],
              ),
              SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: _areaField,
                  ),
                  SizedBox(width: AppTheme.dimensions.space.mini.horizontalSpacing),
                  Flexible(
                    flex: 1,
                    child: _categoryField,
                  ),
                ],
              ),
              SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
              SecondaryButton.small(
                text: 'Limpar filtros',
                onPressed: onClear,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget get _textField {
    final searchTextController = TextEditingController(text: selectedText);

    return AppTextField(
      controller: searchTextController,
      hintText: 'Buscar por título',
      onChanged: onTextChange,
      useDebounce: true,
    );
  }

  Widget get _areaField {
    return AppDropdownField<PostsAreas>(
      value: selectedArea,
      items: PostsAreas.values,
      itemToString: (area) => area.portuguese,
      hintText: 'Selecionar área',
      onChanged: (area) {
        if (area == null) return;
        onAreaChange(PostsAreas.fromName(area));
      },
    );
  }

  Widget get _categoryField {
    return AppDropdownField<CategoryModel>(
      value: selectedCategory,
      items: categories,
      itemToString: (category) => category.title,
      hintText: 'Selecionar categoria',
      onChanged: (category) {
        if (category == null) return;

        final categoryModel = categories.firstWhereOrNull((element) => element.title == category);
        if (categoryModel == null) return;

        onCategoryChange(categoryModel);
      },
    );
  }
}
