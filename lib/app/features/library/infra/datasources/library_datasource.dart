import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:observatorio_geo_hist/app/core/errors/offline_exception.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/environment/app_environment.dart';
import 'package:observatorio_geo_hist/app/core/utils/generator/id_generator.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/paginated_library_document_model.dart';

abstract class LibraryDatasource {
  Future<PaginatedLibraryDocuments> fetchGeographyDocuments(LibraryDocumentsQuery query);
  Future<PaginatedLibraryDocuments> fetchHistoryDocuments(LibraryDocumentsQuery query);
  Future<LibraryDocumentModel?> fetchDocumentBySlug(String slug);
  Future<LibraryDocumentModel?> fetchDocumentById(String id);

  Future<PaginatedLibraryDocuments> fetchListing(LibraryListingQuery query);
  Future<int> countListing(LibraryListingQuery query);

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
  Future<LibraryDocumentModel?> fetchDocumentById(String id) async {
    // Com `/` o Firestore leria o texto como caminho de outra coleção.
    if (id.isEmpty || id.contains('/')) return null;

    final snapshot = await _firestore.collection('library').doc(id).get();
    final data = snapshot.data();
    if (data == null) return null;

    return LibraryDocumentModel.fromJson(data).copyWith(id: snapshot.id);
  }

  // A contagem usa a mesma ordenação da lista para aproveitar os mesmos índices.
  Query _listingQuery(LibraryListingQuery listing) {
    Query query = _baseQuery(area: listing.area.value);

    if (listing.type != null) {
      query = query.where('type', isEqualTo: listing.type!.value);
    }
    if (listing.categories.isNotEmpty) {
      query = query.where(
        'category',
        arrayContainsAny: listing.categories.map((category) => category.value).toList(),
      );
    }
    if (listing.year != null) {
      query = query.where('year', isEqualTo: listing.year);
    }

    final search = listing.searchText.trim();
    if (search.isNotEmpty) {
      final field = listing.searchField.field;
      query = query
          .where(field, isGreaterThanOrEqualTo: search)
          .where(field, isLessThanOrEqualTo: '$search\uf8ff');
    }

    // Com busca, a ordem continua por data: é o formato que os índices do painel já cobrem.
    return query.orderBy('createdAt', descending: true);
  }

  @override
  Future<PaginatedLibraryDocuments> fetchListing(LibraryListingQuery listing) async {
    try {
      Query query = _listingQuery(listing);
      if (listing.startAfterDocument != null) {
        query = query.startAfterDocument(listing.startAfterDocument!);
      }

      // Um a mais diz se existe próxima página sem precisar de um clique que volte vazio.
      final snapshot = await query.limit(listing.limit + 1).get();
      if (snapshot.docs.isEmpty && snapshot.metadata.isFromCache) throw const OfflineException();
      final hasMore = snapshot.docs.length > listing.limit;
      final docs = hasMore ? snapshot.docs.sublist(0, listing.limit) : snapshot.docs;

      return PaginatedLibraryDocuments(
        documents: [
          for (final doc in docs)
            LibraryDocumentModel.fromJson(doc.data() as Map<String, dynamic>).copyWith(id: doc.id),
        ],
        lastDocument: docs.isNotEmpty ? docs.last : null,
        hasMore: hasMore,
      );
    } catch (exception) {
      _loggerService.error('Error fetching library listing: $exception');
      rethrow;
    }
  }

  @override
  Future<int> countListing(LibraryListingQuery listing) async {
    try {
      final snapshot = await _listingQuery(listing).count().get();
      return snapshot.count ?? 0;
    } catch (exception) {
      _loggerService.error('Error counting library listing: $exception');
      rethrow;
    }
  }

  @override
  Future<Map<DocumentType, int>> countByType(String area) async {
    try {
      const types = DocumentType.values;
      final snapshots = await Future.wait([
        for (final type in types)
          _baseQuery(area: area).where('type', isEqualTo: type.value).count().get(),
      ]);

      return {
        for (final (index, type) in types.indexed) type: snapshots[index].count ?? 0,
      };
    } catch (exception) {
      _loggerService.error('Error counting by type: $exception');
      rethrow;
    }
  }

  @override
  Future<Map<DocumentCategory, int>> countByCategory(String area) async {
    try {
      const categories = DocumentCategory.values;
      final snapshots = await Future.wait([
        for (final category in categories)
          _baseQuery(area: area).where('category', arrayContains: category.value).count().get(),
      ]);

      return {
        for (final (index, category) in categories.indexed) category: snapshots[index].count ?? 0,
      };
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
        if (!AppEnvironment.current.hasStorage) {
          throw UnsupportedError('Storage desabilitado no ambiente de dev');
        }

        final name = '${document.slug ?? document.title}_&&&_$documentId';
        final extension = file.extension ?? '';

        final ref = _storage.ref('library/${document.area.bucketKey}/$name.$extension');
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

      if (!AppEnvironment.current.hasStorage) return;

      try {
        final name = '${document.slug ?? document.title}_&&&_$id';
        final extension = getFileExtension(document.documentUrl);

        final fileRef = _storage.ref('library/${document.area.bucketKey}/$name.$extension');

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

enum LibrarySearchField {
  title('title', 'título'),
  author('author', 'autor'),
  institution('institution', 'instituição');

  final String field;
  final String label;
  const LibrarySearchField(this.field, this.label);
}

class LibraryListingQuery {
  final DocumentArea area;
  final DocumentType? type;
  final List<DocumentCategory> categories;
  final int? year;
  final LibrarySearchField searchField;
  final String searchText;
  final DocumentSnapshot? startAfterDocument;
  final int limit;

  const LibraryListingQuery({
    required this.area,
    this.type,
    this.categories = const [],
    this.year,
    this.searchField = LibrarySearchField.title,
    this.searchText = '',
    this.startAfterDocument,
    this.limit = 20,
  });
}
