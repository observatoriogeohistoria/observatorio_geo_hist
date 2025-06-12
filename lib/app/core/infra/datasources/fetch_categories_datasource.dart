import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/models/united/categories_by_area.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';

abstract class FetchCategoriesDatasource {
  Future<CategoriesByArea> fetchCategories();
}

class FetchCategoriesDatasourceImpl implements FetchCategoriesDatasource {
  final FirebaseFirestore _firestore;
  final LoggerService _loggerService;

  FetchCategoriesDatasourceImpl(this._firestore, this._loggerService);

  @override
  Future<CategoriesByArea> fetchCategories() async {
    try {
      final historyQuerySnapshot =
          await _firestore.collection('posts').where('areas', arrayContains: 'historia').get();

      final geographyQuerySnapshot =
          await _firestore.collection('posts').where('areas', arrayContains: 'geografia').get();

      if (historyQuerySnapshot.docs.isEmpty && geographyQuerySnapshot.docs.isEmpty) {
        return CategoriesByArea();
      }

      final historyCategories = await Future.wait(historyQuerySnapshot.docs.map((doc) async {
        final data = doc.data();
        final category = CategoryModel.fromJson(data);
        final types = await _fetchPostTypesForCategory(category.key);
        return category.copyWith(
          areas: [PostsAreas.history],
          postsTypes: types,
        );
      }));

      final geographyCategories = await Future.wait(geographyQuerySnapshot.docs.map((doc) async {
        final data = doc.data();
        final category = CategoryModel.fromJson(data);
        final types = await _fetchPostTypesForCategory(category.key);
        return category.copyWith(
          areas: [PostsAreas.geography],
          postsTypes: types,
        );
      }));

      historyCategories.sort((a, b) => a.title.compareTo(b.title));
      geographyCategories.sort((a, b) => a.title.compareTo(b.title));

      return CategoriesByArea(
        history: historyCategories,
        geography: geographyCategories,
      );
    } catch (exception, stackTrace) {
      _loggerService.error('Error fetching history and geography categories: $exception',
          stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<List<PostType>> _fetchPostTypesForCategory(String categoryId) async {
    try {
      final snapshot = await _firestore
          .collectionGroup('category_posts')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      final types = snapshot.docs
          .map((doc) => doc.data()['type'] as String?)
          .whereType<String>()
          .map((typeString) => PostType.values.byName(typeString))
          .toSet()
          .toList();

      return types;
    } catch (e, stackTrace) {
      _loggerService.error('Error fetching post types for category $categoryId: $e',
          stackTrace: stackTrace);
      return [];
    }
  }
}
