import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';

abstract class PanelCountsDatasource {
  Future<int> countPosts(PostType type);
  Future<int> countCategories();
  Future<int> countLibraryDocuments(DocumentArea area);
  Future<int> countTeamMembers();
  Future<int> countActiveUsers();
}

class PanelCountsDatasourceImpl implements PanelCountsDatasource {
  final FirebaseFirestore _firestore;
  final LoggerService _loggerService;

  PanelCountsDatasourceImpl(this._firestore, this._loggerService);

  @override
  Future<int> countPosts(PostType type) => _count(
        'posts of type ${type.name}',
        _firestore.collectionGroup('category_posts').where('type', isEqualTo: type.name),
      );

  @override
  Future<int> countCategories() => _count('categories', _firestore.collection('posts'));

  @override
  Future<int> countLibraryDocuments(DocumentArea area) => _count(
        'library documents in ${area.value}',
        _firestore.collection('library').where('area', isEqualTo: area.value),
      );

  @override
  Future<int> countTeamMembers() => _count('team members', _firestore.collection('team'));

  @override
  Future<int> countActiveUsers() async {
    final users = _firestore.collection('users');
    final all = await _count('users', users);
    final deleted = await _count('deleted users', users.where('isDeleted', isEqualTo: true));
    return all - deleted;
  }

  Future<int> _count(String what, Query query) async {
    try {
      final snapshot = await query.count().get();
      return snapshot.count ?? 0;
    } catch (exception, stackTrace) {
      _loggerService.error('Error counting $what: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }
}
