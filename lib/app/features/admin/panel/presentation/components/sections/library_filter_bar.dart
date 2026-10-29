import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/field/search_field.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_filter_bar.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_segmented_control.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_toggle_chip.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/listing/library_category_filter.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/listing/library_filter_select.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/listing/library_year_field.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/stores/filter_documents_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Filters live in [FilterDocumentsStore]; each change calls [onChanged] to reload.
class LibraryFilterBar extends StatelessWidget {
  const LibraryFilterBar({
    required this.area,
    required this.onAreaChanged,
    required this.store,
    required this.titleController,
    required this.authorController,
    required this.institutionController,
    required this.showMore,
    required this.onShowMoreChanged,
    required this.onChanged,
    super.key,
  });

  final DocumentArea area;
  final ValueChanged<DocumentArea> onAreaChanged;
  final FilterDocumentsStore store;
  final TextEditingController titleController;
  final TextEditingController authorController;
  final TextEditingController institutionController;
  final bool showMore;
  final ValueChanged<bool> onShowMoreChanged;
  final VoidCallback onChanged;

  static String? _text(String text) => text.trim().isEmpty ? null : text.trim();

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final fieldWidth =
        ScreenUtils.isMobile(context) ? double.infinity : components.panelFilterFieldWidth;
    final categories = store.categories;

    SearchField field(TextEditingController controller, String hint, ValueChanged<String?> set) {
      return SearchField(
        controller: controller,
        hint: hint,
        semanticLabel: hint,
        height: components.panelControlHeight,
        keepClearSpace: false,
        onSearch: (text) {
          set(_text(text));
          onChanged();
        },
      );
    }

    return PanelFilterBar(
      leading: [
        PanelSegmentedControl<DocumentArea>(
          semanticLabel: 'Área da biblioteca',
          segments: [
            for (final area in DocumentArea.values) PanelSegment(area, area.value),
          ],
          value: area,
          onChanged: onAreaChanged,
        ),
      ],
      search: field(titleController, 'Buscar por título', store.setTitle),
      filters: [
        LibraryFilterSelect<DocumentType?>(
          semanticLabel: 'Tipo',
          height: components.panelControlHeight,
          options: [
            const LibraryFilterOption(null, 'Todos os tipos'),
            for (final type in DocumentType.values) LibraryFilterOption(type, type.value),
          ],
          value: store.type,
          onSelected: (type) {
            store.setType(type);
            onChanged();
          },
        ),
        LibraryCategoryFilter(
          categories: DocumentCategory.values,
          counts: null,
          selected: categories,
          onToggle: (category) {
            store.setCategories(
              categories.contains(category)
                  ? [...categories.where((selected) => selected != category)]
                  : [...categories, category],
            );
            onChanged();
          },
          onClear: () {
            store.setCategories([]);
            onChanged();
          },
        ),
        PanelToggleChip(
          label: 'Mais filtros',
          icon: Icons.tune,
          value: showMore,
          onChanged: onShowMoreChanged,
        ),
      ],
      below: showMore
          ? Wrap(
              spacing: components.panelFilterGap,
              runSpacing: components.panelFilterGap,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: fieldWidth,
                  child: field(authorController, 'Autor', store.setAuthor),
                ),
                SizedBox(
                  width: fieldWidth,
                  child: field(institutionController, 'Instituição', store.setInstitution),
                ),
                LibraryYearField(
                  value: store.year,
                  onChanged: (text) {
                    store.setYear(int.tryParse(text));
                    onChanged();
                  },
                ),
              ],
            )
          : null,
    );
  }
}
