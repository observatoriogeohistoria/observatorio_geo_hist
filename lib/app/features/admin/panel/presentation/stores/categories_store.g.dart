// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CategoriesStore on CategoriesStoreBase, Store {
  late final _$categoriesAtom =
      Atom(name: 'CategoriesStoreBase.categories', context: context);

  @override
  ObservableList<CategoryModel> get categories {
    _$categoriesAtom.reportRead();
    return super.categories;
  }

  @override
  set categories(ObservableList<CategoryModel> value) {
    _$categoriesAtom.reportWrite(value, super.categories, () {
      super.categories = value;
    });
  }

  late final _$stateAtom =
      Atom(name: 'CategoriesStoreBase.state', context: context);

  @override
  ManageCategoriesState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(ManageCategoriesState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$getCategoriesAsyncAction =
      AsyncAction('CategoriesStoreBase.getCategories', context: context);

  @override
  Future<void> getCategories() {
    return _$getCategoriesAsyncAction.run(() => super.getCategories());
  }

  late final _$createOrUpdateCategoryAsyncAction = AsyncAction(
      'CategoriesStoreBase.createOrUpdateCategory',
      context: context);

  @override
  Future<void> createOrUpdateCategory(CategoryModel category) {
    return _$createOrUpdateCategoryAsyncAction
        .run(() => super.createOrUpdateCategory(category));
  }

  late final _$deleteCategoryAsyncAction =
      AsyncAction('CategoriesStoreBase.deleteCategory', context: context);

  @override
  Future<void> deleteCategory(CategoryModel category) {
    return _$deleteCategoryAsyncAction
        .run(() => super.deleteCategory(category));
  }

  @override
  String toString() {
    return '''
categories: ${categories},
state: ${state}
    ''';
  }
}
