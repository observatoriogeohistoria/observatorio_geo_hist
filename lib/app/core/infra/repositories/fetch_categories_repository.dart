import 'package:fpdart/fpdart.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';
import 'package:observatorio_geo_hist/app/core/errors/fetch_categories_failures.dart';
import 'package:observatorio_geo_hist/app/core/infra/datasources/fetch_categories_datasource.dart';
import 'package:observatorio_geo_hist/app/core/models/united/categories_by_area.dart';

abstract class FetchCategoriesRepository {
  Future<Either<Failure, CategoriesByArea>> fetchCategories();
}

class FetchCategoriesRepositoryImpl implements FetchCategoriesRepository {
  final FetchCategoriesDatasource _datasource;

  FetchCategoriesRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, CategoriesByArea>> fetchCategories() async {
    try {
      final categories = await _datasource.fetchCategories();
      return Right(categories);
    } catch (error) {
      return const Left(FetchCategoriesFailure());
    }
  }
}
