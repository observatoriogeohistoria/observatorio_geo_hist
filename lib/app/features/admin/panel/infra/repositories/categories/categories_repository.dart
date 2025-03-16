import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/datasources/categories/categories_datasource.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/errors/categories_failures.dart';

abstract class CategoriesRepository {
  Future<Either<Failure, List<CategoryModel>>> getCategories();
  Future<Either<Failure, CategoryModel>> createOrUpdateCategory(CategoryModel category);
  Future<Either<Failure, Unit>> deleteCategory(CategoryModel category);
}

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesDatasource _categoriesDatasource;

  CategoriesRepositoryImpl(this._categoriesDatasource);

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final categories = await _categoriesDatasource.getCategories();
      return Right(categories);
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure.fromException(error));
    } catch (error) {
      return const Left(GetCategoriesFailure());
    }
  }

  @override
  Future<Either<Failure, CategoryModel>> createOrUpdateCategory(CategoryModel category) async {
    try {
      final result = await _categoriesDatasource.createOrUpdateCategory(category);
      return Right(result);
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure.fromException(error));
    } catch (error) {
      return const Left(CreateOrUpdateCategoryFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCategory(CategoryModel category) async {
    try {
      await _categoriesDatasource.deleteCategory(category);
      return const Right(unit);
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure.fromException(error));
    } catch (error) {
      return const Left(DeleteCategoryFailure());
    }
  }
}
