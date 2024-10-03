import 'package:fpdart/fpdart.dart';
import 'package:observatorio_geo_hist/app/core/errors/failure.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/datasources/fetch_navbuttons_categories_datasource.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/navbutton_category_model.dart';

abstract class FetchNavButtonsCategoriesRepository {
  Future<Either<Failure, List<NavButtonCategoryModel>>> fetchHistoryCategories();
  Future<Either<Failure, List<NavButtonCategoryModel>>> fetchGeographyCategories();
}

class FetchNavButtonsCategoriesRepositoryImpl implements FetchNavButtonsCategoriesRepository {
  final FetchNavButtonsCategoriesDatasource _datasource;

  FetchNavButtonsCategoriesRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<NavButtonCategoryModel>>> fetchHistoryCategories() async {
    try {
      final categories = await _datasource.fetchHistoryCategories();
      return Right(categories);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, List<NavButtonCategoryModel>>> fetchGeographyCategories() async {
    try {
      final categories = await _datasource.fetchGeographyCategories();
      return Right(categories);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }
}
