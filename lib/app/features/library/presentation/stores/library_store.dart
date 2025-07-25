import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/models/states/crud_states.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/datasources/library_datasource.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/repositories/library_repository.dart';

part 'library_store.g.dart';

class LibraryStore = LibraryStoreBase with _$LibraryStore;

abstract class LibraryStoreBase with Store {
  final LibraryRepository _repository;

  LibraryStoreBase(this._repository);

  @observable
  CrudState fetchState = CrudInitialState();

  @observable
  CrudState manageState = CrudInitialState();

  @observable
  Observable<LibraryDocumentModel?> selectedDocument = Observable<LibraryDocumentModel?>(null);

  @observable
  ObservableMap<DocumentArea, List<LibraryDocumentModel>> documentsByArea =
      ObservableMap<DocumentArea, List<LibraryDocumentModel>>();

  @observable
  ObservableMap<DocumentArea, bool> hasMore = ObservableMap<DocumentArea, bool>();

  Map<DocumentArea, DocumentSnapshot?> _lastDocument = {
    for (DocumentArea area in DocumentArea.values) area: null
  };

  DocumentType? _lastType;
  List<DocumentCategory>? _lastCategories;

  String? _lastTitle;
  String? _lastAuthor;
  String? _lastInstitution;

  int? _lastYear;

  @action
  void reset() {
    fetchState = CrudInitialState();

    documentsByArea.clear();
    hasMore = {for (DocumentArea area in DocumentArea.values) area: true}.asObservable();
    selectedDocument.value = null;

    _lastDocument = {for (DocumentArea area in DocumentArea.values) area: null};
    _lastType = null;
    _lastCategories = null;
    _lastTitle = null;
    _lastAuthor = null;
    _lastInstitution = null;
    _lastYear = null;
  }

  @action
  Future<void> fetchDocumentsByArea(
    DocumentArea area, {
    DocumentType? type,
    List<DocumentCategory>? categories,
    String? title,
    String? author,
    String? institution,
    int? year,
  }) async {
    bool shouldReset = type != _lastType ||
        categories != _lastCategories ||
        title != _lastTitle ||
        author != _lastAuthor ||
        institution != _lastInstitution ||
        year != _lastYear;

    if (shouldReset) {
      documentsByArea.clear();
      hasMore = {for (DocumentArea a in DocumentArea.values) a: true}.asObservable();

      _lastDocument = {for (DocumentArea a in DocumentArea.values) a: null};
    }

    if (hasMore[area] == false) return;

    fetchState = CrudLoadingState(isRefreshing: fetchState is! CrudInitialState && !shouldReset);

    final query = LibraryDocumentsQuery(
      area: area,
      type: type,
      categories: categories,
      title: title,
      author: author,
      institution: institution,
      year: year,
      startAfterDocument: _lastDocument[area],
    );

    final result = await _repository.fetchDocuments(query);

    result.fold(
      (failure) {
        fetchState = CrudErrorState(failure);
      },
      (paginatedDocuments) {
        final newDocs = documentsByArea[area] ?? [];
        newDocs.addAll(paginatedDocuments.documents);

        documentsByArea[area] = newDocs.asObservable();
        hasMore[area] = paginatedDocuments.hasMore;

        _lastType = type;
        _lastCategories = categories;
        _lastTitle = title;
        _lastAuthor = author;
        _lastInstitution = institution;
        _lastYear = year;
        _lastDocument[area] = paginatedDocuments.lastDocument;

        fetchState = CrudSuccessState();
      },
    );
  }

  @action
  Future<void> fetchDocumentBySlug(String slug) async {
    fetchState = CrudLoadingState();

    final result = await _repository.fetchDocumentBySlug(slug);

    result.fold(
      (failure) {
        fetchState = CrudErrorState(failure);
        selectedDocument.value = null;
      },
      (document) {
        selectedDocument.value = document;
        fetchState = CrudSuccessState();
      },
    );
  }

  @action
  Future<void> createOrUpdateDocument(
    LibraryDocumentModel document,
    FileModel? file,
  ) async {
    manageState = CrudLoadingState(isRefreshing: true);

    final result = await _repository.createOrUpdateDocument(document, file);

    result.fold(
      (failure) => manageState = CrudErrorState(failure),
      (data) {
        manageState = CrudSuccessState(message: 'Documento criado/atualizado com sucesso');

        reset();
        fetchDocumentsByArea(data.area);
      },
    );
  }

  @action
  Future<void> deleteDocument(LibraryDocumentModel document) async {
    if (document.id == null) return;

    manageState = CrudLoadingState(isRefreshing: true);

    final result = await _repository.deleteDocument(document);

    result.fold(
      (failure) {
        manageState = CrudErrorState(failure);
      },
      (data) {
        List<LibraryDocumentModel> byArea = documentsByArea[document.area] ?? [];
        byArea.removeWhere((d) => d.id == document.id);

        documentsByArea[document.area] = byArea.asObservable();

        manageState = CrudSuccessState(message: 'Documento deletado com sucesso');
      },
    );
  }
}
