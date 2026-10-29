// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_listing_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LibraryListingStore on LibraryListingStoreBase, Store {
  Computed<bool>? _$hasFiltersComputed;

  @override
  bool get hasFilters =>
      (_$hasFiltersComputed ??= Computed<bool>(() => super.hasFilters,
              name: 'LibraryListingStoreBase.hasFilters'))
          .value;
  Computed<bool>? _$isSearchingComputed;

  @override
  bool get isSearching =>
      (_$isSearchingComputed ??= Computed<bool>(() => super.isSearching,
              name: 'LibraryListingStoreBase.isSearching'))
          .value;
  Computed<List<DocumentCategory>>? _$visibleCategoriesComputed;

  @override
  List<DocumentCategory> get visibleCategories =>
      (_$visibleCategoriesComputed ??= Computed<List<DocumentCategory>>(
              () => super.visibleCategories,
              name: 'LibraryListingStoreBase.visibleCategories'))
          .value;

  late final _$statusAtom =
      Atom(name: 'LibraryListingStoreBase.status', context: context);

  @override
  LibraryListingStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(LibraryListingStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  late final _$documentsAtom =
      Atom(name: 'LibraryListingStoreBase.documents', context: context);

  @override
  List<LibraryDocumentModel> get documents {
    _$documentsAtom.reportRead();
    return super.documents;
  }

  @override
  set documents(List<LibraryDocumentModel> value) {
    _$documentsAtom.reportWrite(value, super.documents, () {
      super.documents = value;
    });
  }

  late final _$hasMoreAtom =
      Atom(name: 'LibraryListingStoreBase.hasMore', context: context);

  @override
  bool get hasMore {
    _$hasMoreAtom.reportRead();
    return super.hasMore;
  }

  @override
  set hasMore(bool value) {
    _$hasMoreAtom.reportWrite(value, super.hasMore, () {
      super.hasMore = value;
    });
  }

  late final _$isLoadingMoreAtom =
      Atom(name: 'LibraryListingStoreBase.isLoadingMore', context: context);

  @override
  bool get isLoadingMore {
    _$isLoadingMoreAtom.reportRead();
    return super.isLoadingMore;
  }

  @override
  set isLoadingMore(bool value) {
    _$isLoadingMoreAtom.reportWrite(value, super.isLoadingMore, () {
      super.isLoadingMore = value;
    });
  }

  late final _$loadMoreFailedAtom =
      Atom(name: 'LibraryListingStoreBase.loadMoreFailed', context: context);

  @override
  bool get loadMoreFailed {
    _$loadMoreFailedAtom.reportRead();
    return super.loadMoreFailed;
  }

  @override
  set loadMoreFailed(bool value) {
    _$loadMoreFailedAtom.reportWrite(value, super.loadMoreFailed, () {
      super.loadMoreFailed = value;
    });
  }

  late final _$totalAtom =
      Atom(name: 'LibraryListingStoreBase.total', context: context);

  @override
  int? get total {
    _$totalAtom.reportRead();
    return super.total;
  }

  @override
  set total(int? value) {
    _$totalAtom.reportWrite(value, super.total, () {
      super.total = value;
    });
  }

  late final _$typeCountsAtom =
      Atom(name: 'LibraryListingStoreBase.typeCounts', context: context);

  @override
  Map<DocumentType, int>? get typeCounts {
    _$typeCountsAtom.reportRead();
    return super.typeCounts;
  }

  @override
  set typeCounts(Map<DocumentType, int>? value) {
    _$typeCountsAtom.reportWrite(value, super.typeCounts, () {
      super.typeCounts = value;
    });
  }

  late final _$categoryCountsAtom =
      Atom(name: 'LibraryListingStoreBase.categoryCounts', context: context);

  @override
  Map<DocumentCategory, int>? get categoryCounts {
    _$categoryCountsAtom.reportRead();
    return super.categoryCounts;
  }

  @override
  set categoryCounts(Map<DocumentCategory, int>? value) {
    _$categoryCountsAtom.reportWrite(value, super.categoryCounts, () {
      super.categoryCounts = value;
    });
  }

  late final _$searchFieldAtom =
      Atom(name: 'LibraryListingStoreBase.searchField', context: context);

  @override
  LibrarySearchField get searchField {
    _$searchFieldAtom.reportRead();
    return super.searchField;
  }

  @override
  set searchField(LibrarySearchField value) {
    _$searchFieldAtom.reportWrite(value, super.searchField, () {
      super.searchField = value;
    });
  }

  late final _$searchTextAtom =
      Atom(name: 'LibraryListingStoreBase.searchText', context: context);

  @override
  String get searchText {
    _$searchTextAtom.reportRead();
    return super.searchText;
  }

  @override
  set searchText(String value) {
    _$searchTextAtom.reportWrite(value, super.searchText, () {
      super.searchText = value;
    });
  }

  late final _$typeAtom =
      Atom(name: 'LibraryListingStoreBase.type', context: context);

  @override
  DocumentType? get type {
    _$typeAtom.reportRead();
    return super.type;
  }

  @override
  set type(DocumentType? value) {
    _$typeAtom.reportWrite(value, super.type, () {
      super.type = value;
    });
  }

  late final _$yearAtom =
      Atom(name: 'LibraryListingStoreBase.year', context: context);

  @override
  int? get year {
    _$yearAtom.reportRead();
    return super.year;
  }

  @override
  set year(int? value) {
    _$yearAtom.reportWrite(value, super.year, () {
      super.year = value;
    });
  }

  late final _$categoriesAtom =
      Atom(name: 'LibraryListingStoreBase.categories', context: context);

  @override
  List<DocumentCategory> get categories {
    _$categoriesAtom.reportRead();
    return super.categories;
  }

  @override
  set categories(List<DocumentCategory> value) {
    _$categoriesAtom.reportWrite(value, super.categories, () {
      super.categories = value;
    });
  }

  late final _$_fetchAsyncAction =
      AsyncAction('LibraryListingStoreBase._fetch', context: context);

  @override
  Future<void> _fetch() {
    return _$_fetchAsyncAction.run(() => super._fetch());
  }

  late final _$loadMoreAsyncAction =
      AsyncAction('LibraryListingStoreBase.loadMore', context: context);

  @override
  Future<void> loadMore() {
    return _$loadMoreAsyncAction.run(() => super.loadMore());
  }

  late final _$LibraryListingStoreBaseActionController =
      ActionController(name: 'LibraryListingStoreBase', context: context);

  @override
  Future<void> load(DocumentArea area) {
    final _$actionInfo = _$LibraryListingStoreBaseActionController.startAction(
        name: 'LibraryListingStoreBase.load');
    try {
      return super.load(area);
    } finally {
      _$LibraryListingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> search(String text) {
    final _$actionInfo = _$LibraryListingStoreBaseActionController.startAction(
        name: 'LibraryListingStoreBase.search');
    try {
      return super.search(text);
    } finally {
      _$LibraryListingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> setSearchField(LibrarySearchField field) {
    final _$actionInfo = _$LibraryListingStoreBaseActionController.startAction(
        name: 'LibraryListingStoreBase.setSearchField');
    try {
      return super.setSearchField(field);
    } finally {
      _$LibraryListingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> setType(DocumentType? value) {
    final _$actionInfo = _$LibraryListingStoreBaseActionController.startAction(
        name: 'LibraryListingStoreBase.setType');
    try {
      return super.setType(value);
    } finally {
      _$LibraryListingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> setYear(String text) {
    final _$actionInfo = _$LibraryListingStoreBaseActionController.startAction(
        name: 'LibraryListingStoreBase.setYear');
    try {
      return super.setYear(text);
    } finally {
      _$LibraryListingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> toggleCategory(DocumentCategory category) {
    final _$actionInfo = _$LibraryListingStoreBaseActionController.startAction(
        name: 'LibraryListingStoreBase.toggleCategory');
    try {
      return super.toggleCategory(category);
    } finally {
      _$LibraryListingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> clearCategories() {
    final _$actionInfo = _$LibraryListingStoreBaseActionController.startAction(
        name: 'LibraryListingStoreBase.clearCategories');
    try {
      return super.clearCategories();
    } finally {
      _$LibraryListingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> clearAll() {
    final _$actionInfo = _$LibraryListingStoreBaseActionController.startAction(
        name: 'LibraryListingStoreBase.clearAll');
    try {
      return super.clearAll();
    } finally {
      _$LibraryListingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> retry() {
    final _$actionInfo = _$LibraryListingStoreBaseActionController.startAction(
        name: 'LibraryListingStoreBase.retry');
    try {
      return super.retry();
    } finally {
      _$LibraryListingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _setTotal(int? value) {
    final _$actionInfo = _$LibraryListingStoreBaseActionController.startAction(
        name: 'LibraryListingStoreBase._setTotal');
    try {
      return super._setTotal(value);
    } finally {
      _$LibraryListingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _setAreaCounts(
      Map<DocumentType, int>? types, Map<DocumentCategory, int>? categories) {
    final _$actionInfo = _$LibraryListingStoreBaseActionController.startAction(
        name: 'LibraryListingStoreBase._setAreaCounts');
    try {
      return super._setAreaCounts(types, categories);
    } finally {
      _$LibraryListingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
status: ${status},
documents: ${documents},
hasMore: ${hasMore},
isLoadingMore: ${isLoadingMore},
loadMoreFailed: ${loadMoreFailed},
total: ${total},
typeCounts: ${typeCounts},
categoryCounts: ${categoryCounts},
searchField: ${searchField},
searchText: ${searchText},
type: ${type},
year: ${year},
categories: ${categories},
hasFilters: ${hasFilters},
isSearching: ${isSearching},
visibleCategories: ${visibleCategories}
    ''';
  }
}
