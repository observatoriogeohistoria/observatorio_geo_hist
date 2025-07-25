import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';

class PaginatedLibraryDocuments {
  final List<LibraryDocumentModel> documents;
  final DocumentSnapshot? lastDocument;
  final bool hasMore;

  PaginatedLibraryDocuments({
    required this.documents,
    required this.lastDocument,
    required this.hasMore,
  });
}
