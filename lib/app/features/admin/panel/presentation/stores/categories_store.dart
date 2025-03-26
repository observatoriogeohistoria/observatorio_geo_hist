import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/repositories/categories_repository.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/states/categories_states.dart';

part 'categories_store.g.dart';

class CategoriesStore = CategoriesStoreBase with _$CategoriesStore;

abstract class CategoriesStoreBase with Store {
  final CategoriesRepository _categoriesRepository;

  CategoriesStoreBase(this._categoriesRepository);

  @observable
  ObservableList<CategoryModel> categories = ObservableList<CategoryModel>();

  @observable
  ManageCategoriesState state = ManageCategoriesInitialState();

  @action
  Future<void> getCategories() async {
    if (state is ManageCategoriesLoadingState) return;
    if (categories.isNotEmpty) return;

    state = ManageCategoriesLoadingState();

    final result = await _categoriesRepository.getCategories();

    result.fold(
      (failure) => state = ManageCategoriesErrorState(failure),
      (categories) {
        this.categories = categories.asObservable();
        state = ManageCategoriesSuccessState();
      },
    );
  }

  @action
  Future<void> createOrUpdateCategory(CategoryModel category) async {
    state = ManageCategoriesLoadingState(isRefreshing: true);

    final result = await _categoriesRepository.createOrUpdateCategory(category);

    result.fold(
      (failure) => state = ManageCategoriesErrorState(failure),
      (_) {
        final index = categories.indexWhere((c) => c.key == category.key);
        index >= 0
            ? categories.replaceRange(index, index + 1, [category])
            : categories.add(category);

        state = ManageCategoriesSuccessState(
          message: index >= 0 ? 'Categoria atualizada com sucesso' : 'Categoria criada com sucesso',
        );
      },
    );
  }

  @action
  Future<void> deleteCategory(CategoryModel category) async {
    state = ManageCategoriesLoadingState(isRefreshing: true);

    final result = await _categoriesRepository.deleteCategory(category);

    result.fold(
      (failure) => state = ManageCategoriesErrorState(failure),
      (_) {
        categories.removeWhere((c) => c.key == category.key);
        state = ManageCategoriesSuccessState(message: 'Categoria deletada com sucesso');
      },
    );
  }
}
