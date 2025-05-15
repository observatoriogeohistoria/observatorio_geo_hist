import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        bool canEdit = authStore.user?.permissions.canEditCategoriesSection ?? false;

        return CrudSection<CategoryModel>(
          title: 'Categorias',
          canEdit: canEdit,
          store: categoriesStore,
          itemBuilder: (item, index) {
            return CategoryCard(
              category: item,
              index: index + 1,
              onDelete: () => categoriesStore.deleteItem(item),
              onEdit: () => showCreateOrUpdateCategoryDialog(
                context,
                category: item,
                onCreateOrUpdate: (i) => categoriesStore.createOrUpdateItem(i),
              ),
              canEdit: canEdit,
            );
          },
          onCreatePressed: () {
            showCreateOrUpdateCategoryDialog(
              context,
              onCreateOrUpdate: (item) => categoriesStore.createOrUpdateItem(item),
            );
          },
        );
      },
    );
  }
}
