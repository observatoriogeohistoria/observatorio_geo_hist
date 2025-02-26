import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/datasources/firebase_auth_datasource.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';

abstract class UsersDatasource {
  Future<List<UserModel>> getUsers();
  Future<void> createUser(UserModel user, String password);
  Future<void> updateUser(UserModel user);
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
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();

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
  Future<void> createUser(UserModel user, String password) async {
    try {
      final userCredential = await _firebaseAuthDatasource.createUser(user.email, password);
      if (userCredential == null) throw Exception('Error creating user');

      final newUser = user.copyWith(id: userCredential.uid);
      await _firestore.collection('users').doc(newUser.id).set(newUser.toJson());
    } catch (exception, stackTrace) {
      _loggerService.error('Error creating user: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toJson());
    } catch (exception, stackTrace) {
      _loggerService.error('Error updating user: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update({'isDeleted': true});
    } catch (exception, stackTrace) {
      _loggerService.error('Error deleting user: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }
}
