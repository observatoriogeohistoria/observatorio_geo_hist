import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/generator/id_generator.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/paginated_library_document_model.dart';

abstract class LibraryDatasource {
  Future<PaginatedLibraryDocuments> fetchGeographyDocuments(LibraryDocumentsQuery query);
  Future<PaginatedLibraryDocuments> fetchHistoryDocuments(LibraryDocumentsQuery query);
  Future<LibraryDocumentModel?> fetchDocumentBySlug(String slug);

  Future<Map<DocumentType, int>> countByType(String area);
  Future<Map<DocumentCategory, int>> countByCategory(String area);

  Future<LibraryDocumentModel> createOrUpdateDocument(
      LibraryDocumentModel document, FileModel? file);
  Future<void> deleteDocument(LibraryDocumentModel document);
}

class LibraryDatasourceImpl implements LibraryDatasource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final LoggerService _loggerService;

  LibraryDatasourceImpl(this._firestore, this._storage, this._loggerService);

  static String get _bucket => 'gs://observatorio-geo-hist.firebasestorage.app';

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
    if (libraryQuery?.categories?.isNotEmpty ?? false) {
      query = query.where('category',
          arrayContainsAny: libraryQuery?.categories?.map((e) => e.value).toList());
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
        final id = doc.id;

        return LibraryDocumentModel.fromJson(data).copyWith(id: id);
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
  Future<LibraryDocumentModel?> fetchDocumentBySlug(String slug) async {
    final snapshot =
        await _firestore.collection('library').where('slug', isEqualTo: slug).limit(1).get();
    if (snapshot.docs.isEmpty) return null;

    final data = snapshot.docs.first.data();
    return LibraryDocumentModel.fromJson(data);
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

  @override
  Future<LibraryDocumentModel> createOrUpdateDocument(
    LibraryDocumentModel document,
    FileModel? file,
  ) async {
    try {
      final documentId = document.id ?? IdGenerator.generate();
      String? url;

      if (file != null && file.bytes != null) {
        final name = '${document.slug ?? document.title}_&&&_$documentId';
        final extension = file.extension ?? '';

        final ref = _storage
            .refFromURL(_bucket)
            .child('library/${document.area.bucketKey}/$name.$extension');
        await ref.putData(file.bytes!);

        url = await ref.getDownloadURL();
      }

      final newDocument = document.copyWith(documentUrl: url, id: documentId);
      final ref = _firestore.collection('library').doc(documentId);

      await ref.set(newDocument.toJson(), SetOptions(merge: true));

      return newDocument;
    } catch (exception, stackTrace) {
      _loggerService.error('Error creating media: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteDocument(LibraryDocumentModel document) async {
    try {
      final id = document.id;
      if (id == null) throw Exception('Document ID is required');

      final docRef = _firestore.collection('library').doc(id);
      await docRef.delete();

      try {
        final name = '${document.slug ?? document.title}_&&&_$id';
        final extension = getFileExtension(document.documentUrl);

        final fileRef = _storage
            .refFromURL(_bucket)
            .child('library/${document.area.bucketKey}/$name.$extension');

        await fileRef.delete();
      } catch (exception, stackTrace) {
        _loggerService.error('Error deleting document file: $exception', stackTrace: stackTrace);
      }
    } catch (exception, stackTrace) {
      _loggerService.error('Error deleting document: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }
}

class LibraryDocumentsQuery {
  final DocumentArea area;
  final DocumentType? type;
  final List<DocumentCategory>? categories;
  final String? title;
  final String? author;
  final String? institution;
  final int? year;
  final DocumentSnapshot? startAfterDocument;
  final int limit;

  LibraryDocumentsQuery({
    required this.area,
    this.type,
    this.categories,
    this.title,
    this.author,
    this.institution,
    this.year,
    this.startAfterDocument,
    this.limit = 10,
  });
}
