import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/datasources/firebase_auth_datasource.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<AuthFailure, UserModel>> login(String email, String password);
  Future<Either<AuthFailure, Unit>> logout();
  Future<Either<AuthFailure, UserModel>> currentUser();
}

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  Future<Either<AuthFailure, UserModel>> login(String email, String password) async {
    try {
      final user = await _datasource.signIn(email, password);

      if (user != null) return Right(user);

      return const Left(UserNotFound());
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure.fromException(error));
    } catch (_) {
      return const Left(ServerError());
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> logout() async {
    try {
      await _datasource.signOut();
      return const Right(unit);
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure.fromException(error));
    } catch (_) {
      throw const Left(ServerError());
    }
  }

  @override
  Future<Either<AuthFailure, UserModel>> currentUser() async {
    try {
      final user = await _datasource.currentUser();

      if (user != null) return Right(user);
      return const Left(UserNotFound());
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure.fromException(error));
    } catch (_) {
      throw const Left(UserNotFound());
    }
  }
}
