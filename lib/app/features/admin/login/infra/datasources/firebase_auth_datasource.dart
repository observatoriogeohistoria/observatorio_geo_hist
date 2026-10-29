import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/core/utils/environment/app_environment.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';

abstract class FirebaseAuthDatasource {
  Future<UserModel?> signIn(String email, String password);
  Future<void> signOut();
  Future<User?> createUser(String email, String password);
  Future<UserModel?> currentUser();
}

class FirebaseAuthDatasourceImpl implements FirebaseAuthDatasource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final LoggerService _loggerService;

  FirebaseAuthDatasourceImpl(this._firebaseAuth, this._firestore, this._loggerService);

  static const _userCreationAppName = 'UserCreation';

  @override
  Future<User?> createUser(String email, String password) async {
    final auth = FirebaseAuth.instanceFor(app: await _userCreationApp());

    try {
      final userCredential =
          await auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (exception, stackTrace) {
      _loggerService.error('Error creating user: $exception', stackTrace: stackTrace);
      rethrow;
    } finally {
      await auth.signOut();
    }
  }

  // A secondary app keeps the admin signed in while the new account is created. It is reused,
  // never deleted: FirebaseAuth caches its instance by app name and would keep the deleted one.
  Future<FirebaseApp> _userCreationApp() async {
    final existing = Firebase.apps.where((app) => app.name == _userCreationAppName);
    if (existing.isNotEmpty) return existing.first;

    return Firebase.initializeApp(
      name: _userCreationAppName,
      options: AppEnvironment.current.firebaseOptions,
    );
  }

  @override
  Future<UserModel?> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return _userFromUid(userCredential.user?.uid);
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
  Future<UserModel?> currentUser() async {
    return _userFromUid(_firebaseAuth.currentUser?.uid);
  }

  Future<UserModel?> _userFromUid(String? uid) async {
    if (uid == null) return null;

    try {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(uid).get();

      if (!snapshot.exists) {
        _loggerService.error('User not found');
        return null;
      }

      return UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    } catch (exception, stackTrace) {
      _loggerService.error('Error getting user from uid: $exception', stackTrace: stackTrace);
      return null;
    }
  }
}
