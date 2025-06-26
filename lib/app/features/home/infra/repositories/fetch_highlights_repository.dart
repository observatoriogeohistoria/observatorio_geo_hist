import 'package:fpdart/fpdart.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/datasources/fetch_highlights_datasource.dart';
import 'package:observatorio_geo_hist/app/features/posts/infra/errors/failures.dart';

abstract class FetchHighlightsRepository {
  Future<Either<Failure, List<PostModel>>> fetchHighlights(List<CategoryModel> categories);
}

class FetchHighlightsRepositoryImpl implements FetchHighlightsRepository {
  final FetchHighlightsDatasource datasource;

  FetchHighlightsRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<PostModel>>> fetchHighlights(List<CategoryModel> categories) async {
    try {
      final highlights = await datasource.fetchHighlights(categories);
      return Right(highlights);
    } catch (error) {
      return const Left(FetchHighlightsFailure());
    }
  }
}
