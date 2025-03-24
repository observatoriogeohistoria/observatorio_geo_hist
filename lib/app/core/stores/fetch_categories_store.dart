import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/infra/repositories/fetch_categories_repository.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';

part 'fetch_categories_store.g.dart';

class FetchCategoriesStore = FetchCategoriesStoreBase with _$FetchCategoriesStore;

abstract class FetchCategoriesStoreBase with Store {
  final FetchCategoriesRepository _repository;

  FetchCategoriesStoreBase(this._repository);

  @observable
  ObservableList<CategoryModel> historyCategories = ObservableList<CategoryModel>();

  @observable
  ObservableList<CategoryModel> geographyCategories = ObservableList<CategoryModel>();

  @observable
  CategoryModel? selectedCategory;

  @action
  Future<void> fetchHistoryCategories() async {
    final result = await _repository.fetchHistoryCategories();

    result.fold(
      (error) {},
      (categories) {
        historyCategories = categories.asObservable();
      },
    );
  }

  @action
  Future<void> fetchGeographyCategories() async {
    final result = await _repository.fetchGeographyCategories();

    result.fold(
      (error) {},
      (categories) {
        geographyCategories = categories.asObservable();
      },
    );
  }

  @action
  void setSelectedCategory(CategoryModel? category) {
    selectedCategory = category;
  }

  CategoryModel? getCategoryByAreaAndKey(PostsAreas area, String key) {
    if (area != PostsAreas.history && area != PostsAreas.geography) return null;

    final categories = area == PostsAreas.history ? historyCategories : geographyCategories;
    return categories.firstWhereOrNull((category) => category.area == area && category.key == key);
  }
}
