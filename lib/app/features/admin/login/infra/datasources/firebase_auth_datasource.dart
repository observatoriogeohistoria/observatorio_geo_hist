import 'package:firebase_auth/firebase_auth.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/exceptions.dart';

abstract class FirebaseAuthDatasource {
  Future<User?> signIn(String email, String password);
  Future<void> signOut();
  Stream<User?> authStateChanges();
}

class FirebaseAuthDatasourceImpl implements FirebaseAuthDatasource {
  final FirebaseAuth _firebaseAuth;
  final LoggerService _loggerService;

  FirebaseAuthDatasourceImpl(this._firebaseAuth, this._loggerService);

  @override
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: "taina@gmail.com",
        password: "Amanh3c3r*",
      );
      return userCredential.user;
    } catch (exception) {
      _loggerService.error('Error signing in: $exception');
      throw const FirebaseSignInException();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (exception) {
      _loggerService.error('Error signing out: $exception');
      throw const FirebaseSignOutException();
    }
  }

  @override
  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }
}
