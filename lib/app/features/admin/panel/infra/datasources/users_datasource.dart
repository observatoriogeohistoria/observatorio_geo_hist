import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/datasources/firebase_auth_datasource.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';

abstract class UsersDatasource {
  Future<List<UserModel>> getUsers();
  Future<UserModel> createUser(UserModel user, String password);
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(UserModel user);
}

class UsersDatasourceImpl implements UsersDatasource {
  final FirebaseAuthDatasource _firebaseAuthDatasource;
  final FirebaseFirestore _firestore;
  final LoggerService _loggerService;

  UsersDatasourceImpl(this._firebaseAuthDatasource, this._firestore, this._loggerService);

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').orderBy('name').get();

      final docs = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();

      List<UserModel> users = docs.map((user) => UserModel.fromJson(user)).toList();

      return users;
    } catch (exception, stackTrace) {
      _loggerService.error('Error fetching users: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<UserModel> createUser(UserModel user, String password) async {
    try {
      final userCredential = await _firebaseAuthDatasource.createUser(user.email, password);
      if (userCredential == null) throw Exception('Error creating user');

      final newUser = user.copyWith(id: userCredential.uid);

      DocumentReference ref = _firestore.collection('users').doc(newUser.id);
      await ref.set(newUser.toJson(), SetOptions(merge: true));

      return newUser;
    } catch (exception, stackTrace) {
      _loggerService.error('Error creating user: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    try {
      if (user.id == null) throw Exception('User ID is required');

      DocumentReference ref = _firestore.collection('users').doc(user.id);
      await ref.set(user.toJson(), SetOptions(merge: true));

      return user;
    } catch (exception, stackTrace) {
      _loggerService.error('Error updating user: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteUser(UserModel user) async {
    try {
      if (user.id == null) throw Exception('User ID is required');

      DocumentReference ref = _firestore.collection('users').doc(user.id);
      await ref.delete();
    } catch (exception, stackTrace) {
      _loggerService.error('Error deleting user: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }
}
