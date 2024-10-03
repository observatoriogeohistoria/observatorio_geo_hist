import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/navbutton_category_model.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/repositories/fetch_navbuttons_categories_repository.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  final FetchNavButtonsCategoriesRepository _repository;

  HomeStoreBase(this._repository);

  @observable
  List<NavButtonCategoryModel> historyCategories = [];

  @observable
  List<NavButtonCategoryModel> geographyCategories = [];

  @action
  Future<void> fetchHistoryCategories() async {
    final result = await _repository.fetchHistoryCategories();

    result.fold(
      (failure) => print(failure),
      (categories) => historyCategories = categories,
    );
  }

  @action
  Future<void> fetchGeographyCategories() async {
    final result = await _repository.fetchGeographyCategories();

    result.fold(
      (failure) => print(failure),
      (categories) => geographyCategories = categories,
    );
  }
}
