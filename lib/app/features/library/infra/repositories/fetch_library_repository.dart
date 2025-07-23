import 'package:fpdart/fpdart.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/datasources/fetch_library_datasource.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/paginated_library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/posts/infra/errors/failures.dart';

abstract class FetchLibraryRepository {
  Future<Either<Failure, PaginatedLibraryDocuments>> fetchGeographyDocuments(
      LibraryDocumentsQuery query);
  Future<Either<Failure, PaginatedLibraryDocuments>> fetchHistoryDocuments(
      LibraryDocumentsQuery query);

  // Future<Either<Failure, LibraryDocumentModel>> fetchGeographyDocumentById(String postId);
  // Future<Either<Failure, LibraryDocumentModel>> fetchHistoryDocumentById(String postId);
}

class FetchLibraryRepositoryImpl implements FetchLibraryRepository {
  final FetchLibraryDatasource _datasource;

  FetchLibraryRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, PaginatedLibraryDocuments>> fetchGeographyDocuments(
      LibraryDocumentsQuery query) async {
    try {
      final documents = await _datasource.fetchGeographyDocuments(query);

      return Right(documents);
    } catch (error) {
      return const Left(FetchPostsFailure());
    }
  }

  @override
  Future<Either<Failure, PaginatedLibraryDocuments>> fetchHistoryDocuments(
      LibraryDocumentsQuery query) async {
    try {
      final documents = await _datasource.fetchHistoryDocuments(query);
      return Right(documents);
    } catch (error) {
      return const Left(FetchPostByIdFailure());
    }
  }
}
