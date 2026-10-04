import 'package:fpdart/fpdart.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/datasources/library_datasource.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/errors/failures.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/paginated_library_document_model.dart';

abstract class LibraryRepository {
  Future<Either<Failure, PaginatedLibraryDocuments>> fetchDocuments(LibraryDocumentsQuery query);
  Future<Either<Failure, LibraryDocumentModel>> fetchDocumentByAddress(String key);

  Future<Either<Failure, PaginatedLibraryDocuments>> fetchListing(LibraryListingQuery query);
  Future<Either<Failure, int>> countListing(LibraryListingQuery query);
  Future<Either<Failure, Map<DocumentType, int>>> countByType(DocumentArea area);
  Future<Either<Failure, Map<DocumentCategory, int>>> countByCategory(DocumentArea area);

  Future<Either<Failure, LibraryDocumentModel>> createOrUpdateDocument(
      LibraryDocumentModel document, FileModel? file);
  Future<Either<Failure, void>> deleteDocument(LibraryDocumentModel document);
}

class LibraryRepositoryImpl implements LibraryRepository {
  final LibraryDatasource _datasource;

  LibraryRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, PaginatedLibraryDocuments>> fetchDocuments(
      LibraryDocumentsQuery query) async {
    try {
      final response = query.area == DocumentArea.geografia
          ? await _datasource.fetchGeographyDocuments(query)
          : await _datasource.fetchHistoryDocuments(query);

      return Right(response);
    } catch (_) {
      return const Left(FetchLibraryFailure());
    }
  }

  // Links compartilhados antes da troca para o identificador ainda levam o slug.
  @override
  Future<Either<Failure, LibraryDocumentModel>> fetchDocumentByAddress(String key) async {
    try {
      final document =
          await _datasource.fetchDocumentById(key) ?? await _datasource.fetchDocumentBySlug(key);
      if (document == null) return const Left(LibraryDocumentNotFoundFailure());

      return Right(document);
    } catch (_) {
      return const Left(FetchLibraryFailure());
    }
  }

  @override
  Future<Either<Failure, PaginatedLibraryDocuments>> fetchListing(
    LibraryListingQuery query,
  ) async {
    try {
      return Right(await _datasource.fetchListing(query));
    } catch (_) {
      return const Left(FetchLibraryFailure());
    }
  }

  @override
  Future<Either<Failure, int>> countListing(LibraryListingQuery query) async {
    try {
      return Right(await _datasource.countListing(query));
    } catch (_) {
      return const Left(CountLibraryFailure());
    }
  }

  @override
  Future<Either<Failure, Map<DocumentType, int>>> countByType(DocumentArea area) async {
    try {
      return Right(await _datasource.countByType(area.value));
    } catch (_) {
      return const Left(CountLibraryFailure());
    }
  }

  @override
  Future<Either<Failure, Map<DocumentCategory, int>>> countByCategory(DocumentArea area) async {
    try {
      return Right(await _datasource.countByCategory(area.value));
    } catch (_) {
      return const Left(CountLibraryFailure());
    }
  }

  @override
  Future<Either<Failure, LibraryDocumentModel>> createOrUpdateDocument(
    LibraryDocumentModel document,
    FileModel? file,
  ) async {
    try {
      final response = await _datasource.createOrUpdateDocument(document, file);
      return Right(response);
    } catch (_) {
      return const Left(CreateOrUpdateLibraryDocumentFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteDocument(LibraryDocumentModel document) async {
    try {
      await _datasource.deleteDocument(document);
      return const Right(null);
    } catch (_) {
      return const Left(DeleteLibraryDocumentFailure());
    }
  }
}
