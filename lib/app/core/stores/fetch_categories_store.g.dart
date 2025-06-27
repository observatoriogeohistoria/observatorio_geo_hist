// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_categories_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FetchCategoriesStore on FetchCategoriesStoreBase, Store {
  late final _$categoriesAtom =
      Atom(name: 'FetchCategoriesStoreBase.categories', context: context);

  @override
  CategoriesByArea get categories {
    _$categoriesAtom.reportRead();
    return super.categories;
  }

  @override
  set categories(CategoriesByArea value) {
    _$categoriesAtom.reportWrite(value, super.categories, () {
      super.categories = value;
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

  late final _$stateAtom =
      Atom(name: 'FetchCategoriesStoreBase.state', context: context);

  @override
  FetchCategoriesState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(FetchCategoriesState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$fetchCategoriesAsyncAction =
      AsyncAction('FetchCategoriesStoreBase.fetchCategories', context: context);

  @override
  Future<void> fetchCategories() {
    return _$fetchCategoriesAsyncAction.run(() => super.fetchCategories());
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
categories: ${categories},
selectedCategory: ${selectedCategory},
state: ${state}
    ''';
  }
}
