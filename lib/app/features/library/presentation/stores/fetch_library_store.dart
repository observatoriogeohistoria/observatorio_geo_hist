import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/datasources/fetch_library_datasource.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/repositories/fetch_library_repository.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/stores/states/fetch_library_states.dart';

part 'fetch_library_store.g.dart';

class FetchLibraryStore = FetchLibraryStoreBase with _$FetchLibraryStore;

abstract class FetchLibraryStoreBase with Store {
  final FetchLibraryRepository _repository;

  FetchLibraryStoreBase(this._repository);

  @observable
  FetchLibraryState state = FetchLibraryInitialState();

  @observable
  ObservableMap<String, List<LibraryDocumentModel>> documentsByArea =
      ObservableMap<String, List<LibraryDocumentModel>>();

  @observable
  ObservableMap<DocumentArea, bool> hasMore = ObservableMap<DocumentArea, bool>();

  Map<DocumentArea, DocumentSnapshot?> _lastDocument = {
    for (DocumentArea area in DocumentArea.values) area: null
  };

  DocumentType? _lastType;
  DocumentCategory? _lastCategory;

  String? _lastTitle;
  String? _lastAuthor;
  String? _lastInstitution;

  int? _lastYear;

  @action
  void reset() {
    state = FetchLibraryInitialState();

    documentsByArea.clear();
    hasMore = {for (DocumentArea area in DocumentArea.values) area: true}.asObservable();

    _lastDocument = {for (DocumentArea area in DocumentArea.values) area: null};
    _lastType = null;
    _lastCategory = null;
    _lastTitle = null;
    _lastAuthor = null;
    _lastInstitution = null;
    _lastYear = null;
  }

  @action
  Future<void> fetchDocumentsByArea(
    DocumentArea area, {
    DocumentType? type,
    DocumentCategory? category,
    String? title,
    String? author,
    String? institution,
    int? year,
  }) async {
    bool shouldReset = type != _lastType ||
        category != _lastCategory ||
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

    state = FetchLibraryLoadingState(
      isRefreshing: state is! FetchLibraryInitialState && !shouldReset,
    );

    final query = LibraryDocumentsQuery(
      type: type,
      category: category,
      title: title,
      author: author,
      institution: institution,
      year: year,
      startAfterDocument: _lastDocument[area],
    );

    final result = area == DocumentArea.geografia
        ? await _repository.fetchGeographyDocuments(query)
        : await _repository.fetchHistoryDocuments(query);

    result.fold(
      (failure) {
        state = FetchLibraryErrorState(failure.message);
      },
      (paginatedDocuments) {
        final newDocs = documentsByArea[area.name] ?? [];
        newDocs.addAll(paginatedDocuments.documents);

        documentsByArea[area.name] = newDocs.asObservable();
        hasMore[area] = paginatedDocuments.hasMore;

        _lastType = type;
        _lastCategory = category;
        _lastTitle = title;
        _lastAuthor = author;
        _lastInstitution = institution;
        _lastYear = year;
        _lastDocument[area] = paginatedDocuments.lastDocument;

        state = FetchLibrarySuccessState();
      },
    );
  }
}
