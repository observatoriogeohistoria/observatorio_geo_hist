import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/field/search_field.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/strings/strings.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/confirm_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_or_update_category_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_area_filter.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_filter_bar.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_list.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_list_states.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/panel_section_header.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/category_row.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/crud_section.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/panel_action.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/categories_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/panel_counts_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/enums/sidebar_item.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class CategoriesSection extends StatefulWidget {
  const CategoriesSection({super.key});

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  late final AuthStore authStore = PanelSetup.getIt<AuthStore>();
  late final CategoriesStore categoriesStore = PanelSetup.getIt<CategoriesStore>();
  late final PanelCountsStore countsStore = PanelSetup.getIt<PanelCountsStore>();
  final _pending = PendingPanelAction();
  final _searchController = TextEditingController();

  String _query = '';
  PostsAreas? _area;

  bool get _hasFilter => _query.isNotEmpty || _area != null;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _save(CategoryModel category) {
    _pending.start(PanelAction.save);
    categoriesStore.createOrUpdateItem(category);
  }

  Future<void> _delete(CategoryModel category) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Excluir esta categoria?',
      message: '“${category.title}” sai do site e do painel. Não dá para desfazer.',
    );
    if (!confirmed) return;
    _pending.start(PanelAction.delete);
    categoriesStore.deleteItem(category);
  }

  void _openForm([CategoryModel? category]) {
    showCreateOrUpdateCategoryDialog(context, category: category, onCreateOrUpdate: _save);
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _area = null;
    });
  }

  bool _matches(CategoryModel category) {
    if (_area != null && !category.areas.contains(_area)) return false;
    return _query.isEmpty || foldForSearch(category.title).contains(_query);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final canEdit = authStore.user?.permissions.canEditCategoriesSection ?? false;

        return CrudSection<CategoryModel>(
          header: PanelSectionHeader(
            eyebrow: SidebarItem.categories.eyebrow,
            title: SidebarItem.categories.title,
            summary: countSummary(
              countsStore.counts.categories,
              'categoria',
              'categorias',
              note: 'aparecem no menu de História e Geografia',
            ),
            actionLabel: canEdit ? 'Nova categoria' : null,
            onAction: _openForm,
          ),
          filterBar: PanelFilterBar(
            search: SearchField(
              controller: _searchController,
              hint: 'Buscar categoria',
              semanticLabel: 'Buscar categoria',
              height: AppTheme.dimensions.components.panelControlHeight,
              onSearch: (text) => setState(() => _query = foldForSearch(text)),
            ),
            filters: [
              PanelAreaFilter(value: _area, onChanged: (area) => setState(() => _area = area)),
            ],
          ),
          store: categoriesStore,
          pending: _pending,
          messages: const {
            PanelAction.save: 'Categoria salva.',
            PanelAction.delete: 'Categoria excluída.',
          },
          empty: PanelEmptyInfo(
            icon: Icons.label_outline,
            title: 'Nenhuma categoria ainda',
            message: 'Crie a primeira para organizar as publicações no menu do site.',
            actionLabel: canEdit ? 'Nova categoria' : null,
            onAction: _openForm,
          ),
          filter: _hasFilter ? _matches : null,
          onClearFilters: _clearFilters,
          bodyBuilder: (items, footer) => PanelList(
            itemCount: items.length,
            footer: footer,
            itemBuilder: (context, index) {
              final category = items[index];
              return CategoryRow(
                key: ValueKey(category.key),
                category: category,
                canEdit: canEdit,
                onEdit: () => _openForm(category),
                onDelete: () => _delete(category),
              );
            },
          ),
        );
      },
    );
  }
}
