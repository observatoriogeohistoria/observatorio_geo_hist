import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/loading/circular_loading.dart';
import 'package:observatorio_geo_hist/app/core/components/loading/linear_loading.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/category_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_or_update_category_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/categories_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/states/categories_states.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class CategoriesSection extends StatefulWidget {
  const CategoriesSection({super.key});

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  late final CategoriesStore categoriesStore = PanelSetup.getIt<CategoriesStore>();
  late final AuthStore authStore = PanelSetup.getIt<AuthStore>();

  List<ReactionDisposer> _reactions = [];

  @override
  void initState() {
    super.initState();

    categoriesStore.getCategories();

    _reactions = [
      reaction((_) => categoriesStore.state, (state) {
        if (state is ManageCategoriesErrorState) {
          final error = state.failure;
          Messenger.showError(context, error.message);

          if (error is Forbidden) authStore.logout();
        }

        if (state is ManageCategoriesSuccessState) {
          if (state.message.isNotEmpty) {
            Messenger.showSuccess(context, state.message);
          }
        }
      }),
    ];
  }

  @override
  void dispose() {
    for (var reaction in _reactions) {
      reaction.reaction.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppHeadline.big(
          text: 'Categorias',
          color: AppTheme.colors.orange,
        ),
        SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
        Align(
          alignment: Alignment.centerRight,
          child: SecondaryButton.medium(
            text: 'Criar categoria',
            onPressed: () {
              showCreateOrUpdateCategoryDialog(
                context,
                onCreateOrUpdate: (category) => categoriesStore.createOrUpdateCategory(category),
              );
            },
          ),
        ),
        Observer(
          builder: (context) {
            final state = categoriesStore.state;

            if (state is ManageCategoriesLoadingState && state.isRefreshing) {
              return const LinearLoading();
            }

            return const SizedBox.shrink();
          },
        ),
        SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
        Expanded(
          child: Observer(
            builder: (context) {
              final state = categoriesStore.state;

              if (state is ManageCategoriesLoadingState && !state.isRefreshing) {
                return const Center(child: CircularLoading());
              }

              final categories = categoriesStore.categories;

              return ListView.separated(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.only(
                  bottom: AppTheme.dimensions.space.large.verticalSpacing,
                ),
                separatorBuilder: (context, index) {
                  final isLast = index == categories.length - 1;

                  return isLast
                      ? const SizedBox()
                      : SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing);
                },
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return CategoryCard(
                    category: category,
                    index: index + 1,
                    onDelete: () => categoriesStore.deleteCategory(category),
                    onEdit: () {
                      showCreateOrUpdateCategoryDialog(
                        context,
                        category: category,
                        onCreateOrUpdate: (category) =>
                            categoriesStore.createOrUpdateCategory(category),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
