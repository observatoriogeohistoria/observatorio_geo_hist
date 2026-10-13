import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/confirm_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/panel_action.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/panel_section_header.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/panel_counts_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/enums/sidebar_item.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/category_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_or_update_category_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/crud_section.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/categories_store.dart';

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

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        bool canEdit = authStore.user?.permissions.canEditCategoriesSection ?? false;

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
            onAction: () => showCreateOrUpdateCategoryDialog(
              context,
              onCreateOrUpdate: _save,
            ),
          ),
          store: categoriesStore,
          pending: _pending,
          messages: const {
            PanelAction.save: 'Categoria salva.',
            PanelAction.delete: 'Categoria excluída.',
          },
          itemBuilder: (item, index) {
            return CategoryCard(
              category: item,
              index: index + 1,
              onDelete: () => _delete(item),
              onEdit: () => showCreateOrUpdateCategoryDialog(
                context,
                category: item,
                onCreateOrUpdate: _save,
              ),
              canEdit: canEdit,
            );
          },
        );
      },
    );
  }
}
