import 'package:fpdart/fpdart.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';
import 'package:observatorio_geo_hist/app/core/errors/fetch_categories_failures.dart';
import 'package:observatorio_geo_hist/app/core/infra/datasources/fetch_categories_datasource.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';

abstract class FetchCategoriesRepository {
  Future<Either<Failure, List<CategoryModel>>> fetchHistoryCategories();
  Future<Either<Failure, List<CategoryModel>>> fetchGeographyCategories();
}

class FetchCategoriesRepositoryImpl implements FetchCategoriesRepository {
  final FetchCategoriesDatasource _datasource;

  FetchCategoriesRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<CategoryModel>>> fetchHistoryCategories() async {
    try {
      final categories = await _datasource.fetchHistoryCategories();
      return Right(categories);
    } catch (error) {
      return const Left(FetchCategoriesFailure());
    }
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> fetchGeographyCategories() async {
    try {
      final categories = await _datasource.fetchGeographyCategories();
      return Right(categories);
    } catch (error) {
      return const Left(FetchCategoriesFailure());
    }
  }
}
