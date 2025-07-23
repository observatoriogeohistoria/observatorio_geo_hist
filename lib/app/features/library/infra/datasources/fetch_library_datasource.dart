import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/paginated_library_document_model.dart';

abstract class FetchLibraryDatasource {
  Future<PaginatedLibraryDocuments> fetchGeographyDocuments(LibraryDocumentsQuery query);
  Future<PaginatedLibraryDocuments> fetchHistoryDocuments(LibraryDocumentsQuery query);

  Future<Map<DocumentType, int>> countByType(String area);
  Future<Map<DocumentCategory, int>> countByCategory(String area);
}

class FetchLibraryDatasourceImpl implements FetchLibraryDatasource {
  final FirebaseFirestore _firestore;
  final LoggerService _loggerService;

  FetchLibraryDatasourceImpl(this._firestore, this._loggerService);

  Query _baseQuery({required String area}) {
    return _firestore.collection('library').where('area', isEqualTo: area);
  }

  Query _applyFilters(
    Query query, {
    LibraryDocumentsQuery? libraryQuery,
  }) {
    if (libraryQuery?.type != null) {
      query = query.where('type', isEqualTo: libraryQuery?.type?.value);
    }
    if (libraryQuery?.category != null) {
      query = query.where('category', arrayContains: libraryQuery?.category?.value);
    }
    if (libraryQuery?.title != null && libraryQuery!.title!.isNotEmpty) {
      final search = libraryQuery.title!;

      query = query
          .where('title', isGreaterThanOrEqualTo: search)
          .where('title', isLessThanOrEqualTo: '$search\uf8ff');
    }
    if (libraryQuery?.author != null && libraryQuery!.author!.isNotEmpty) {
      final search = libraryQuery.author!;

      query = query
          .where('author', isGreaterThanOrEqualTo: search)
          .where('author', isLessThanOrEqualTo: '$search\uf8ff');
    }
    if (libraryQuery?.institution != null && libraryQuery!.institution!.isNotEmpty) {
      final search = libraryQuery.institution!;

      query = query
          .where('institution', isGreaterThanOrEqualTo: search)
          .where('institution', isLessThanOrEqualTo: '$search\uf8ff');
    }
    if (libraryQuery?.year != null) {
      query = query.where('year', isEqualTo: libraryQuery?.year);
    }

    return query;
  }

  Future<PaginatedLibraryDocuments> _fetchDocuments({
    required DocumentArea area,
    required LibraryDocumentsQuery libraryQuery,
  }) async {
    try {
      Query query = _baseQuery(area: area.value);

      query = _applyFilters(query, libraryQuery: libraryQuery);
      query = query.orderBy('createdAt', descending: true);

      if (libraryQuery.startAfterDocument != null) {
        query = query.startAfterDocument(libraryQuery.startAfterDocument!);
      }

      query = query.limit(libraryQuery.limit);

      final snapshot = await query.get();
      final documents = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return LibraryDocumentModel.fromJson(data);
      }).toList();

      return PaginatedLibraryDocuments(
        documents: documents,
        lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
        hasMore: snapshot.docs.length == libraryQuery.limit,
      );
    } catch (exception) {
      _loggerService.error('Error fetching library documents: $exception');
      rethrow;
    }
  }

  @override
  Future<PaginatedLibraryDocuments> fetchGeographyDocuments(LibraryDocumentsQuery query) async {
    return _fetchDocuments(
      area: DocumentArea.geografia,
      libraryQuery: query,
    );
  }

  @override
  Future<PaginatedLibraryDocuments> fetchHistoryDocuments(LibraryDocumentsQuery query) async {
    return _fetchDocuments(
      area: DocumentArea.historia,
      libraryQuery: query,
    );
  }

  @override
  Future<Map<DocumentType, int>> countByType(String area) async {
    try {
      const types = DocumentType.values;

      final Map<DocumentType, int> counts = {};
      for (final type in types) {
        final countSnap = await _baseQuery(area: area).where('type', isEqualTo: type).count().get();
        counts[type] = countSnap.count ?? 0;
      }

      return counts;
    } catch (exception) {
      _loggerService.error('Error counting by type: $exception');
      rethrow;
    }
  }

  @override
  Future<Map<DocumentCategory, int>> countByCategory(String area) async {
    try {
      const categories = DocumentCategory.values;

      final counts = <DocumentCategory, int>{};
      for (final category in categories) {
        final countSnap =
            await _baseQuery(area: area).where('category', arrayContains: category).count().get();
        counts[category] = countSnap.count ?? 0;
      }

      return counts;
    } catch (exception) {
      _loggerService.error('Error counting by category: $exception');
      rethrow;
    }
  }
}

class LibraryDocumentsQuery {
  final DocumentType? type;
  final DocumentCategory? category;
  final String? title;
  final String? author;
  final String? institution;
  final int? year;
  final DocumentSnapshot? startAfterDocument;
  final int limit;

  LibraryDocumentsQuery({
    this.type,
    this.category,
    this.title,
    this.author,
    this.institution,
    this.year,
    this.startAfterDocument,
    this.limit = 10,
  });
}
