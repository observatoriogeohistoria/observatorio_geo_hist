// ignore_for_file: overridden_fields

import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/repositories/categories_repository.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/crud_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/states/crud_states.dart';

part 'categories_store.g.dart';

class CategoriesStore = CategoriesStoreBase with _$CategoriesStore;

abstract class CategoriesStoreBase extends CrudStore<CategoryModel> with Store {
  final CategoriesRepository _categoriesRepository;

  CategoriesStoreBase(this._categoriesRepository);

  @override
  @observable
  ObservableList<CategoryModel> items = ObservableList<CategoryModel>();

  @override
  @observable
  CrudState state = CrudInitialState();

  @override
  @action
  Future<void> getItems() async {
    if (state is CrudLoadingState) return;
    if (items.isNotEmpty) return;

    state = CrudLoadingState();

    final result = await _categoriesRepository.getCategories();

    result.fold(
      (failure) => state = CrudErrorState(failure),
      (categories) {
        items = categories.asObservable();
        state = CrudSuccessState();
      },
    );
  }

  @override
  @action
  Future<void> createOrUpdateItem(CategoryModel item, {dynamic extra}) async {
    state = CrudLoadingState(isRefreshing: true);

    final result = await _categoriesRepository.createOrUpdateCategory(item);

    result.fold(
      (failure) => state = CrudErrorState(failure),
      (_) {
        final index = items.indexWhere((c) => c.key == item.key);
        index >= 0 ? items.replaceRange(index, index + 1, [item]) : items.add(item);

        state = CrudSuccessState(
          message: index >= 0 ? 'Categoria atualizada com sucesso' : 'Categoria criada com sucesso',
        );
      },
    );
  }

  @override
  @action
  Future<void> deleteItem(CategoryModel item) async {
    state = CrudLoadingState(isRefreshing: true);

    final result = await _categoriesRepository.deleteCategory(item);

    result.fold(
      (failure) => state = CrudErrorState(failure),
      (_) {
        items.removeWhere((c) => c.key == item.key);
        state = CrudSuccessState(message: 'Categoria deletada com sucesso');
      },
    );
  }
}
