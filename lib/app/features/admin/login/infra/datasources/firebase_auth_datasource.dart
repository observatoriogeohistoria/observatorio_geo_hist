import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/firebase_options.dart';

abstract class FirebaseAuthDatasource {
  Future<User?> signIn(String email, String password);
  Future<void> signOut();
  Future<User?> createUser(String email, String password);
  Future<User?> currentUser();
  Stream<User?> authStateChanges();
}

class FirebaseAuthDatasourceImpl implements FirebaseAuthDatasource {
  final FirebaseAuth _firebaseAuth;
  final LoggerService _loggerService;

  FirebaseAuthDatasourceImpl(this._firebaseAuth, this._loggerService);

  @override
  Future<User?> createUser(String email, String password) async {
    try {
      final app = await Firebase.initializeApp(
        name: 'TemporaryApp',
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);
      await app.delete();

      return userCredential.user;
    } catch (exception, stackTrace) {
      _loggerService.error('Error creating user: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } catch (exception, stackTrace) {
      _loggerService.error('Error signing in: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (exception, stackTrace) {
      _loggerService.error('Error signing out: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<User?> currentUser() async {
    return _firebaseAuth.currentUser;
  }

  @override
  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }
}
