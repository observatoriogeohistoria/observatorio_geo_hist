// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LibraryStore on LibraryStoreBase, Store {
  late final _$fetchStateAtom =
      Atom(name: 'LibraryStoreBase.fetchState', context: context);

  @override
  CrudState get fetchState {
    _$fetchStateAtom.reportRead();
    return super.fetchState;
  }

  @override
  set fetchState(CrudState value) {
    _$fetchStateAtom.reportWrite(value, super.fetchState, () {
      super.fetchState = value;
    });
  }

  late final _$manageStateAtom =
      Atom(name: 'LibraryStoreBase.manageState', context: context);

  @override
  CrudState get manageState {
    _$manageStateAtom.reportRead();
    return super.manageState;
  }

  @override
  set manageState(CrudState value) {
    _$manageStateAtom.reportWrite(value, super.manageState, () {
      super.manageState = value;
    });
  }

  late final _$selectedDocumentAtom =
      Atom(name: 'LibraryStoreBase.selectedDocument', context: context);

  @override
  Observable<LibraryDocumentModel?> get selectedDocument {
    _$selectedDocumentAtom.reportRead();
    return super.selectedDocument;
  }

  @override
  set selectedDocument(Observable<LibraryDocumentModel?> value) {
    _$selectedDocumentAtom.reportWrite(value, super.selectedDocument, () {
      super.selectedDocument = value;
    });
  }

  late final _$documentsByAreaAtom =
      Atom(name: 'LibraryStoreBase.documentsByArea', context: context);

  @override
  ObservableMap<DocumentArea, List<LibraryDocumentModel>> get documentsByArea {
    _$documentsByAreaAtom.reportRead();
    return super.documentsByArea;
  }

  @override
  set documentsByArea(
      ObservableMap<DocumentArea, List<LibraryDocumentModel>> value) {
    _$documentsByAreaAtom.reportWrite(value, super.documentsByArea, () {
      super.documentsByArea = value;
    });
  }

  late final _$hasMoreAtom =
      Atom(name: 'LibraryStoreBase.hasMore', context: context);

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

  late final _$fetchDocumentsByAreaAsyncAction =
      AsyncAction('LibraryStoreBase.fetchDocumentsByArea', context: context);

  @override
  Future<void> fetchDocumentsByArea(DocumentArea area,
      {DocumentType? type,
      List<DocumentCategory>? categories,
      String? title,
      String? author,
      String? institution,
      int? year}) {
    return _$fetchDocumentsByAreaAsyncAction.run(() => super
        .fetchDocumentsByArea(area,
            type: type,
            categories: categories,
            title: title,
            author: author,
            institution: institution,
            year: year));
  }

  late final _$fetchDocumentBySlugAsyncAction =
      AsyncAction('LibraryStoreBase.fetchDocumentBySlug', context: context);

  @override
  Future<void> fetchDocumentBySlug(String slug) {
    return _$fetchDocumentBySlugAsyncAction
        .run(() => super.fetchDocumentBySlug(slug));
  }

  late final _$createOrUpdateDocumentAsyncAction =
      AsyncAction('LibraryStoreBase.createOrUpdateDocument', context: context);

  @override
  Future<void> createOrUpdateDocument(
      LibraryDocumentModel document, FileModel? file) {
    return _$createOrUpdateDocumentAsyncAction
        .run(() => super.createOrUpdateDocument(document, file));
  }

  late final _$deleteDocumentAsyncAction =
      AsyncAction('LibraryStoreBase.deleteDocument', context: context);

  @override
  Future<void> deleteDocument(LibraryDocumentModel document) {
    return _$deleteDocumentAsyncAction
        .run(() => super.deleteDocument(document));
  }

  late final _$LibraryStoreBaseActionController =
      ActionController(name: 'LibraryStoreBase', context: context);

  @override
  void reset() {
    final _$actionInfo = _$LibraryStoreBaseActionController.startAction(
        name: 'LibraryStoreBase.reset');
    try {
      return super.reset();
    } finally {
      _$LibraryStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchState: ${fetchState},
manageState: ${manageState},
selectedDocument: ${selectedDocument},
documentsByArea: ${documentsByArea},
hasMore: ${hasMore}
    ''';
  }
}
