import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/errors/failures.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/repositories/library_repository.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/stores/states/library_document_states.dart';

part 'library_document_store.g.dart';

/// One per page: `LibraryStore` belongs to the panel and must not change.
class LibraryDocumentStore = LibraryDocumentStoreBase with _$LibraryDocumentStore;

abstract class LibraryDocumentStoreBase with Store {
  LibraryDocumentStoreBase(this._repository);

  final LibraryRepository _repository;

  @observable
  LibraryDocumentState state = LibraryDocumentInitialState();

  String? _key;

  // Drops the response for a previous URL when the page changes mid-fetch.
  int _request = 0;

  @action
  Future<void> fetch(String key) async {
    _key = key;
    final request = ++_request;
    state = LibraryDocumentLoadingState();

    final result = await _repository.fetchDocumentByAddress(key);
    if (request != _request) return;

    state = result.fold(
      (failure) => failure is LibraryDocumentNotFoundFailure
          ? LibraryDocumentNotFoundState()
          : LibraryDocumentErrorState(),
      LibraryDocumentSuccessState.new,
    );
  }

  @action
  Future<void> retry() async {
    final key = _key;
    if (key != null) await fetch(key);
  }
}
