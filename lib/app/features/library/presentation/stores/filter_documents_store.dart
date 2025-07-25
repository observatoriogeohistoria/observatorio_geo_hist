import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';

part 'filter_documents_store.g.dart';

class FilterDocumentsStore = FilterDocumentsStoreBase with _$FilterDocumentsStore;

abstract class FilterDocumentsStoreBase with Store {
  @observable
  DocumentType? type;

  @observable
  List<DocumentCategory> categories = [];

  @observable
  String? title;

  @observable
  String? author;

  @observable
  String? institution;

  @observable
  int? year;

  @action
  void reset() {
    type = null;
    categories = [];
    title = null;
    author = null;
    institution = null;
    year = null;
  }

  @action
  void setType(DocumentType? type) {
    this.type = type;
  }

  @action
  void setCategories(List<DocumentCategory> categories) {
    this.categories = categories;
  }

  @action
  void setTitle(String? title) {
    this.title = title;
  }

  @action
  void setAuthor(String? author) {
    this.author = author;
  }

  @action
  void setInstitution(String? institution) {
    this.institution = institution;
  }

  @action
  void setYear(int? year) {
    this.year = year;
  }
}
