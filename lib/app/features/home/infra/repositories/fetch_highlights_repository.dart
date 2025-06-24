import 'package:fpdart/fpdart.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/datasources/fetch_highlights_datasource.dart';
import 'package:observatorio_geo_hist/app/features/posts/infra/errors/failures.dart';

abstract class FetchHighlightsRepository {
  Future<Either<Failure, List<PostModel>>> fetchHighlights();
}

class FetchHighlightsRepositoryImpl implements FetchHighlightsRepository {
  final FetchHighlightsDatasource datasource;

  FetchHighlightsRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<PostModel>>> fetchHighlights() async {
    try {
      final highlights = await datasource.fetchHighlights();
      return Right(highlights);
    } catch (error) {
      return const Left(FetchHighlightsFailure());
    }
  }
}
