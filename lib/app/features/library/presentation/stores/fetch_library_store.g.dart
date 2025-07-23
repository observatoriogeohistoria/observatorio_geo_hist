// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_library_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FetchLibraryStore on FetchLibraryStoreBase, Store {
  late final _$stateAtom =
      Atom(name: 'FetchLibraryStoreBase.state', context: context);

  @override
  FetchLibraryState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(FetchLibraryState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$documentsByAreaAtom =
      Atom(name: 'FetchLibraryStoreBase.documentsByArea', context: context);

  @override
  ObservableMap<String, List<LibraryDocumentModel>> get documentsByArea {
    _$documentsByAreaAtom.reportRead();
    return super.documentsByArea;
  }

  @override
  set documentsByArea(ObservableMap<String, List<LibraryDocumentModel>> value) {
    _$documentsByAreaAtom.reportWrite(value, super.documentsByArea, () {
      super.documentsByArea = value;
    });
  }

  late final _$hasMoreAtom =
      Atom(name: 'FetchLibraryStoreBase.hasMore', context: context);

  @override
  ObservableMap<DocumentArea, bool> get hasMore {
    _$hasMoreAtom.reportRead();
    return super.hasMore;
  }

  @override
  set hasMore(ObservableMap<DocumentArea, bool> value) {
    _$hasMoreAtom.reportWrite(value, super.hasMore, () {
      super.hasMore = value;
    });
  }

  late final _$fetchDocumentsByAreaAsyncAction = AsyncAction(
      'FetchLibraryStoreBase.fetchDocumentsByArea',
      context: context);

  @override
  Future<void> fetchDocumentsByArea(DocumentArea area,
      {DocumentType? type,
      DocumentCategory? category,
      String? title,
      String? author,
      String? institution,
      int? year}) {
    return _$fetchDocumentsByAreaAsyncAction.run(() => super
        .fetchDocumentsByArea(area,
            type: type,
            category: category,
            title: title,
            author: author,
            institution: institution,
            year: year));
  }

  late final _$FetchLibraryStoreBaseActionController =
      ActionController(name: 'FetchLibraryStoreBase', context: context);

  @override
  void reset() {
    final _$actionInfo = _$FetchLibraryStoreBaseActionController.startAction(
        name: 'FetchLibraryStoreBase.reset');
    try {
      return super.reset();
    } finally {
      _$FetchLibraryStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
state: ${state},
documentsByArea: ${documentsByArea},
hasMore: ${hasMore}
    ''';
  }
}
