import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/datasources/users/users_datasource.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/errors/users_failures.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';

abstract class UsersRepository {
  Future<Either<Failure, List<UserModel>>> getUsers();
  Future<Either<Failure, Unit>> createUser(UserModel user, String password);
  Future<Either<Failure, Unit>> updateUser(UserModel user);
  Future<Either<Failure, Unit>> deleteUser(UserModel user);
}

class UsersRepositoryImpl implements UsersRepository {
  final UsersDatasource _usersDatasource;

  UsersRepositoryImpl(this._usersDatasource);

  @override
  Future<Either<Failure, List<UserModel>>> getUsers() async {
    try {
      final users = await _usersDatasource.getUsers();
      return Right(users);
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure.fromException(error));
    } catch (error) {
      return const Left(GetUsersFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> createUser(UserModel user, String password) async {
    try {
      await _usersDatasource.createUser(user, password);
      return const Right(unit);
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure.fromException(error));
    } catch (error) {
      return const Left(CreateUserFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUser(UserModel user) async {
    try {
      await _usersDatasource.updateUser(user);
      return const Right(unit);
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure.fromException(error));
    } catch (error) {
      return const Left(UpdateUserFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUser(UserModel user) async {
    try {
      await _usersDatasource.deleteUser(user);
      return const Right(unit);
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure.fromException(error));
    } catch (error) {
      return const Left(DeleteUserFailure());
    }
  }
}
