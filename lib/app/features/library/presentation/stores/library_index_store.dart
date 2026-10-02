import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/repositories/library_repository.dart';

part 'library_index_store.g.dart';

enum LibraryIndexStatus { loading, success, error }

class LibraryIndexStore = LibraryIndexStoreBase with _$LibraryIndexStore;

abstract class LibraryIndexStoreBase with Store {
  LibraryIndexStoreBase(this._repository);

  final LibraryRepository _repository;

  @observable
  LibraryIndexStatus status = LibraryIndexStatus.loading;

  @observable
  Map<DocumentArea, Map<DocumentType, int>>? counts;

  @action
  Future<void> load() async {
    status = LibraryIndexStatus.loading;
    counts = null;

    const areas = DocumentArea.values;
    final results = await Future.wait([for (final area in areas) _repository.countByType(area)]);

    if (results.any((result) => result.isLeft())) {
      status = LibraryIndexStatus.error;
      return;
    }

    counts = {
      for (final (index, area) in areas.indexed) area: results[index].getRight().toNullable()!,
    };
    status = LibraryIndexStatus.success;
  }
}
