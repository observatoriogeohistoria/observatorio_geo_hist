// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on HomeStoreBase, Store {
  late final _$historyCategoriesAtom =
      Atom(name: 'HomeStoreBase.historyCategories', context: context);

  @override
  ObservableList<NavButtonCategoryModel> get historyCategories {
    _$historyCategoriesAtom.reportRead();
    return super.historyCategories;
  }

  @override
  set historyCategories(ObservableList<NavButtonCategoryModel> value) {
    _$historyCategoriesAtom.reportWrite(value, super.historyCategories, () {
      super.historyCategories = value;
    });
  }

  late final _$geographyCategoriesAtom =
      Atom(name: 'HomeStoreBase.geographyCategories', context: context);

  @override
  ObservableList<NavButtonCategoryModel> get geographyCategories {
    _$geographyCategoriesAtom.reportRead();
    return super.geographyCategories;
  }

  @override
  set geographyCategories(ObservableList<NavButtonCategoryModel> value) {
    _$geographyCategoriesAtom.reportWrite(value, super.geographyCategories, () {
      super.geographyCategories = value;
    });
  }

  late final _$fetchHistoryCategoriesAsyncAction =
      AsyncAction('HomeStoreBase.fetchHistoryCategories', context: context);

  @override
  Future<void> fetchHistoryCategories() {
    return _$fetchHistoryCategoriesAsyncAction
        .run(() => super.fetchHistoryCategories());
  }

  late final _$fetchGeographyCategoriesAsyncAction =
      AsyncAction('HomeStoreBase.fetchGeographyCategories', context: context);

  @override
  Future<void> fetchGeographyCategories() {
    return _$fetchGeographyCategoriesAsyncAction
        .run(() => super.fetchGeographyCategories());
  }

  @override
  String toString() {
    return '''
historyCategories: ${historyCategories},
geographyCategories: ${geographyCategories}
    ''';
  }
}
