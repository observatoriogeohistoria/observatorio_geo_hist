import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/infra/repositories/fetch_categories_repository.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/united/categories_by_area.dart';
import 'package:observatorio_geo_hist/app/core/stores/states/fetch_categories_states.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';

part 'fetch_categories_store.g.dart';

class FetchCategoriesStore = FetchCategoriesStoreBase with _$FetchCategoriesStore;

abstract class FetchCategoriesStoreBase with Store {
  final FetchCategoriesRepository _repository;

  FetchCategoriesStoreBase(this._repository);

  @observable
  CategoriesByArea categories = CategoriesByArea();

  @observable
  CategoryModel? selectedCategory;

  @observable
  FetchCategoriesState state = FetchCategoriesInitialState();

  @action
  Future<void> fetchCategories() async {
    state = FetchCategoriesLoadingState();

    final result = await _repository.fetchCategories();

    result.fold(
      (error) {
        state = FetchCategoriesErrorState(error.message);
      },
      (categories) {
        this.categories = categories;
        state = FetchCategoriesSuccessState();
      },
    );
  }

  @action
  void setSelectedCategory(CategoryModel? category) {
    selectedCategory = category;
  }

  CategoryModel? getCategoryByAreaAndKey(PostsAreas area, String key) {
    if (area != PostsAreas.history && area != PostsAreas.geography) return null;

    final categories =
        area == PostsAreas.history ? this.categories.history : this.categories.geography;

    return categories.firstWhereOrNull(
      (category) => category.areas.first == area && category.key == key,
    );
  }
}
