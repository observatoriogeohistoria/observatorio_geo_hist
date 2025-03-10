import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/repositories/categories/categories_repository.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/states/categories_state.dart';

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
  Future<void> getCategories({
    bool emitLoading = true,
    bool force = false,
  }) async {
    if (!force && categories.isNotEmpty) return;
    if (emitLoading) state = ManageCategoriesLoadingState();

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
  Future<void> createCategory(CategoryModel category) async {
    state = ManageCategoriesLoadingState();

    final result = await _categoriesRepository.createOrUpdateCategory(category);

    result.fold(
      (failure) => state = ManageCategoriesErrorState(failure),
      (_) {
        getCategories(emitLoading: false, force: true);
        state = ManageCategoriesSuccessState();
      },
    );
  }

  @action
  Future<void> deleteCategory(CategoryModel category) async {
    state = ManageCategoriesLoadingState();

    final result = await _categoriesRepository.deleteCategory(category);

    result.fold(
      (failure) => state = ManageCategoriesErrorState(failure),
      (_) {
        getCategories(emitLoading: false, force: true);
        state = ManageCategoriesSuccessState();
      },
    );
  }
}
