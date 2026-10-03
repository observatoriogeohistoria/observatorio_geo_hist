import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/datasources/library_datasource.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/repositories/library_repository.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/stores/states/library_listing_states.dart';

part 'library_listing_store.g.dart';

/// Um por página: o painel continua com o próprio store e não divide estado com o site.
class LibraryListingStore = LibraryListingStoreBase with _$LibraryListingStore;

abstract class LibraryListingStoreBase with Store {
  LibraryListingStoreBase(this._repository);

  final LibraryRepository _repository;

  static const pageSize = 20;

  DocumentArea? _area;
  DocumentSnapshot? _cursor;

  // Descarta respostas de filtros ou áreas anteriores que chegam atrasadas.
  int _request = 0;
  int _countsRequest = 0;

  @observable
  LibraryListingStatus status = LibraryListingStatus.initial;

  @observable
  List<LibraryDocumentModel> documents = const [];

  @observable
  bool hasMore = false;

  @observable
  bool isLoadingMore = false;

  @observable
  bool loadMoreFailed = false;

  /// Nulos enquanto carregam ou se a contagem falhou: aí os números somem.
  @observable
  int? total;

  @observable
  Map<DocumentType, int>? typeCounts;

  @observable
  Map<DocumentCategory, int>? categoryCounts;

  @observable
  LibrarySearchField searchField = LibrarySearchField.title;

  @observable
  String searchText = '';

  @observable
  DocumentType? type;

  @observable
  int? year;

  @observable
  List<DocumentCategory> categories = const [];

  @computed
  bool get hasFilters => type != null || year != null || categories.isNotEmpty;

  @computed
  bool get isSearching => searchText.isNotEmpty;

  /// Em ordem alfabética, sem as que não têm documento na área. Sem contagem, todas.
  @computed
  List<DocumentCategory> get visibleCategories {
    final counts = categoryCounts;
    return [
      for (final category in DocumentCategory.values)
        if (counts == null || (counts[category] ?? 0) > 0 || categories.contains(category))
          category,
    ]..sort((a, b) => a.value.toLowerCase().compareTo(b.value.toLowerCase()));
  }

  @action
  Future<void> load(DocumentArea area) {
    _area = area;
    searchField = LibrarySearchField.title;
    searchText = '';
    type = null;
    year = null;
    categories = const [];
    _fetchAreaCounts(area);
    return _fetch();
  }

  @action
  Future<void> search(String text) {
    final normalized = text.trim();
    if (normalized == searchText && status != LibraryListingStatus.error) return Future.value();
    searchText = normalized;
    return _fetch();
  }

  @action
  Future<void> setSearchField(LibrarySearchField field) {
    if (field == searchField) return Future.value();
    searchField = field;
    return isSearching ? _fetch() : Future.value();
  }

  @action
  Future<void> setType(DocumentType? value) {
    if (value == type) return Future.value();
    type = value;
    return _fetch();
  }

  /// Só filtra com o ano completo ou com o campo vazio.
  @action
  Future<void> setYear(String text) {
    final digits = text.trim();
    if (digits.isNotEmpty && digits.length != 4) return Future.value();
    final value = int.tryParse(digits);
    if (value == year) return Future.value();
    year = value;
    return _fetch();
  }

  @action
  Future<void> toggleCategory(DocumentCategory category) {
    categories = categories.contains(category)
        ? categories.where((selected) => selected != category).toList()
        : [...categories, category];
    return _fetch();
  }

  @action
  Future<void> clearCategories() {
    if (categories.isEmpty) return Future.value();
    categories = const [];
    return _fetch();
  }

  @action
  Future<void> clearAll() {
    searchText = '';
    type = null;
    year = null;
    categories = const [];
    return _fetch();
  }

  @action
  Future<void> retry() {
    final area = _area;
    if (area != null && (typeCounts == null || categoryCounts == null)) _fetchAreaCounts(area);
    return _fetch();
  }

  LibraryListingQuery _query({DocumentSnapshot? startAfter}) => LibraryListingQuery(
        area: _area!,
        type: type,
        categories: categories,
        year: year,
        searchField: searchField,
        searchText: _adjustCase(searchText, searchField),
        startAfterDocument: startAfter,
        limit: pageSize,
      );

  // O banco diferencia maiúsculas: títulos e autores estão gravados com inicial maiúscula e
  // instituições quase sempre em caixa alta. Só mexe no termo digitado todo em minúsculas.
  static String _adjustCase(String text, LibrarySearchField field) {
    if (text.isEmpty || text != text.toLowerCase() || text == text.toUpperCase()) return text;
    if (field == LibrarySearchField.institution) return text.toUpperCase();
    return text[0].toUpperCase() + text.substring(1);
  }

  @action
  Future<void> _fetch() async {
    if (_area == null) return;

    final request = ++_request;
    status = LibraryListingStatus.loading;
    documents = const [];
    _cursor = null;
    hasMore = false;
    isLoadingMore = false;
    loadMoreFailed = false;
    total = null;

    final query = _query();
    _fetchTotal(query, request);

    final result = await _repository.fetchListing(query);
    if (request != _request) return;

    result.fold(
      (_) => status = LibraryListingStatus.error,
      (page) {
        documents = page.documents;
        _cursor = page.lastDocument;
        hasMore = page.hasMore;
        status = switch (page.documents.isEmpty) {
          false => LibraryListingStatus.success,
          true when hasFilters || isSearching => LibraryListingStatus.noResults,
          true => LibraryListingStatus.areaEmpty,
        };
      },
    );
  }

  Future<void> _fetchTotal(LibraryListingQuery query, int request) async {
    final result = await _repository.countListing(query);
    if (request != _request) return;
    _setTotal(result.toNullable());
  }

  @action
  void _setTotal(int? value) => total = value;

  Future<void> _fetchAreaCounts(DocumentArea area) async {
    final request = ++_countsRequest;
    _setAreaCounts(null, null);

    final results = await (
      _repository.countByType(area),
      _repository.countByCategory(area),
    ).wait;
    if (request != _countsRequest) return;

    _setAreaCounts(results.$1.toNullable(), results.$2.toNullable());
  }

  @action
  void _setAreaCounts(Map<DocumentType, int>? types, Map<DocumentCategory, int>? categories) {
    typeCounts = types;
    categoryCounts = categories;
  }

  @action
  Future<void> loadMore() async {
    if (_area == null || isLoadingMore || !hasMore) return;

    final request = _request;
    isLoadingMore = true;
    loadMoreFailed = false;

    final result = await _repository.fetchListing(_query(startAfter: _cursor));
    if (request != _request) return;

    isLoadingMore = false;
    result.fold(
      (_) => loadMoreFailed = true,
      (page) {
        documents = [...documents, ...page.documents];
        _cursor = page.lastDocument;
        hasMore = page.hasMore;
      },
    );
  }
}
