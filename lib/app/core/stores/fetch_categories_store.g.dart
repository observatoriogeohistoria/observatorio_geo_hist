// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_categories_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FetchCategoriesStore on FetchCategoriesStoreBase, Store {
  late final _$historyCategoriesAtom = Atom(
      name: 'FetchCategoriesStoreBase.historyCategories', context: context);

  @override
  ObservableList<CategoryModel> get historyCategories {
    _$historyCategoriesAtom.reportRead();
    return super.historyCategories;
  }

  @override
  set historyCategories(ObservableList<CategoryModel> value) {
    _$historyCategoriesAtom.reportWrite(value, super.historyCategories, () {
      super.historyCategories = value;
    });
  }

  late final _$geographyCategoriesAtom = Atom(
      name: 'FetchCategoriesStoreBase.geographyCategories', context: context);

  @override
  ObservableList<CategoryModel> get geographyCategories {
    _$geographyCategoriesAtom.reportRead();
    return super.geographyCategories;
  }

  @override
  set geographyCategories(ObservableList<CategoryModel> value) {
    _$geographyCategoriesAtom.reportWrite(value, super.geographyCategories, () {
      super.geographyCategories = value;
    });
  }

  late final _$selectedCategoryAtom =
      Atom(name: 'FetchCategoriesStoreBase.selectedCategory', context: context);

  @override
  CategoryModel? get selectedCategory {
    _$selectedCategoryAtom.reportRead();
    return super.selectedCategory;
  }

  @override
  set selectedCategory(CategoryModel? value) {
    _$selectedCategoryAtom.reportWrite(value, super.selectedCategory, () {
      super.selectedCategory = value;
    });
  }

  late final _$fetchHistoryCategoriesAsyncAction = AsyncAction(
      'FetchCategoriesStoreBase.fetchHistoryCategories',
      context: context);

  @override
  Future<void> fetchHistoryCategories() {
    return _$fetchHistoryCategoriesAsyncAction
        .run(() => super.fetchHistoryCategories());
  }

  late final _$fetchGeographyCategoriesAsyncAction = AsyncAction(
      'FetchCategoriesStoreBase.fetchGeographyCategories',
      context: context);

  @override
  Future<void> fetchGeographyCategories() {
    return _$fetchGeographyCategoriesAsyncAction
        .run(() => super.fetchGeographyCategories());
  }

  late final _$FetchCategoriesStoreBaseActionController =
      ActionController(name: 'FetchCategoriesStoreBase', context: context);

  @override
  void setSelectedCategory(CategoryModel? category) {
    final _$actionInfo = _$FetchCategoriesStoreBaseActionController.startAction(
        name: 'FetchCategoriesStoreBase.setSelectedCategory');
    try {
      return super.setSelectedCategory(category);
    } finally {
      _$FetchCategoriesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
historyCategories: ${historyCategories},
geographyCategories: ${geographyCategories},
selectedCategory: ${selectedCategory}
    ''';
  }
}
