import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/datasources/firebase_auth_datasource.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';

abstract class AuthRepository {
  Future<Either<AuthFailure, User>> login(String email, String password);
  Future<Either<AuthFailure, Unit>> logout();
  Future<Either<AuthFailure, User>> currentUser();
}

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  Future<Either<AuthFailure, User>> login(String email, String password) async {
    try {
      final user = await _datasource.signIn(email, password);

      if (user != null) return Right(user);

      return const Left(AuthFailure.userNotFound());
    } on FirebaseAuthException catch (error) {
      switch (error.code.toLowerCase()) {
        case 'invalid-credential':
          return left(const AuthFailure.invalidCredentials());
        case 'invalid-email':
          return left(const AuthFailure.invalidEmail());
        case 'user-disabled':
          return left(const AuthFailure.userDisabled());
        case 'user-not-found':
          return left(const AuthFailure.userNotFound());
        case 'wrong-password':
          return left(const AuthFailure.wrongPassword());
        case 'too-many-requests':
          return left(const AuthFailure.tooManyRequests());
        default:
          return left(const AuthFailure.serverError());
      }
    } catch (_) {
      return const Left(AuthFailure.serverError());
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> logout() async {
    try {
      await _datasource.signOut();
      return const Right(unit);
    } catch (_) {
      throw const Left(AuthFailure.serverError());
    }
  }

  @override
  Future<Either<AuthFailure, User>> currentUser() async {
    try {
      final user = await _datasource.currentUser();

      if (user != null) return Right(user);
      return const Left(AuthFailure.userNotFound());
    } catch (_) {
      throw const Left(AuthFailure.userNotFound());
    }
  }
}
