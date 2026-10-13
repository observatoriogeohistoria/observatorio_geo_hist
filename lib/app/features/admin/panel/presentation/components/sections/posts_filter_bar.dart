import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/field/search_field.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_area_filter.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_filter_bar.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_segmented_control.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_toggle_chip.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/listing/library_filter_select.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostsFilterBar extends StatelessWidget {
  const PostsFilterBar({
    required this.searchController,
    required this.onSearch,
    required this.area,
    required this.onAreaChanged,
    required this.categories,
    required this.category,
    required this.onCategoryChanged,
    required this.isPublished,
    required this.onPublishedChanged,
    required this.onlyHighlighted,
    required this.onHighlightedChanged,
    super.key,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final PostsAreas? area;
  final ValueChanged<PostsAreas?> onAreaChanged;

  /// Já filtradas pela área escolhida.
  final List<CategoryModel> categories;
  final CategoryModel? category;
  final ValueChanged<CategoryModel?> onCategoryChanged;
  final bool? isPublished;
  final ValueChanged<bool?> onPublishedChanged;
  final bool onlyHighlighted;
  final ValueChanged<bool> onHighlightedChanged;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;

    return PanelFilterBar(
      search: SearchField(
        controller: searchController,
        hint: 'Buscar por título',
        semanticLabel: 'Buscar por título',
        height: components.panelControlHeight,
        onSearch: onSearch,
      ),
      filters: [
        PanelAreaFilter(value: area, onChanged: onAreaChanged),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: components.panelFilterSelectMaxWidth),
          child: LibraryFilterSelect<String?>(
            semanticLabel: 'Categoria',
            height: components.panelControlHeight,
            options: [
              const LibraryFilterOption(null, 'Todas as categorias'),
              for (final category in categories) LibraryFilterOption(category.key, category.title),
            ],
            value: category?.key,
            onSelected: (key) => onCategoryChanged(
              key == null ? null : categories.firstWhere((category) => category.key == key),
            ),
          ),
        ),
        PanelSegmentedControl<bool?>(
          semanticLabel: 'Situação',
          segments: const [
            PanelSegment(null, 'Todas'),
            PanelSegment(true, 'Publicadas'),
            PanelSegment(false, 'Não publicadas'),
          ],
          value: isPublished,
          onChanged: onPublishedChanged,
        ),
        PanelToggleChip(
          label: 'Destaques',
          icon: Icons.star_border,
          selectedIcon: Icons.star,
          value: onlyHighlighted,
          onChanged: onHighlightedChanged,
        ),
      ],
    );
  }
}
