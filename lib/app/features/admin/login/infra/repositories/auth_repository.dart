import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures/failures.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/datasources/firebase_auth_datasource.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/exceptions.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, User?>> login(String email, String password);
}

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, User?>> login(String email, String password) async {
    try {
      final user = await _datasource.signIn(email, password);
      return Right(user);
    } on FirebaseSignInException catch (error) {
      return Left(SignInFailure(error.message));
    }
  }

  Future<void> logout() async {
    try {
      await _datasource.signOut();
    } on FirebaseSignOutException catch (error) {
      throw SignOutFailure(error.message);
    }
  }

  Stream<User?> observeAuthState() {
    return _datasource.authStateChanges();
  }
}
