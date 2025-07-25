import 'package:fpdart/fpdart.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/datasources/library_datasource.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/errors/failures.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/paginated_library_document_model.dart';

abstract class LibraryRepository {
  Future<Either<Failure, PaginatedLibraryDocuments>> fetchDocuments(LibraryDocumentsQuery query);
  Future<Either<Failure, LibraryDocumentModel?>> fetchDocumentBySlug(String slug);

  // Future<Either<Failure, LibraryDocumentModel>> fetchGeographyDocumentById(String postId);
  // Future<Either<Failure, LibraryDocumentModel>> fetchHistoryDocumentById(String postId);

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

  @override
  Future<Either<Failure, LibraryDocumentModel?>> fetchDocumentBySlug(String slug) async {
    try {
      final response = await _datasource.fetchDocumentBySlug(slug);
      return Right(response);
    } catch (_) {
      return const Left(FetchLibraryFailure());
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
