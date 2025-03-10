import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';

abstract class CategoriesDatasource {
  Future<List<CategoryModel>> getCategories();
  Future<void> createOrUpdateCategory(CategoryModel category);
  Future<void> deleteCategory(CategoryModel category);
}

class CategoriesDatasourceImpl implements CategoriesDatasource {
  final FirebaseFirestore _firestore;
  final LoggerService _loggerService;

  CategoriesDatasourceImpl(this._firestore, this._loggerService);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('posts').get();
      List<CategoryModel> categories = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final categoriesData = data['categories'] as List<dynamic>;

        categories.addAll(categoriesData.map((category) {
          return CategoryModel.fromJson(category, doc.id);
        }).toList());
      }

      return categories;
    } catch (exception, stackTrace) {
      _loggerService.error('Error fetching categories: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> createOrUpdateCategory(CategoryModel category) async {
    try {
      await _firestore
          .collection('posts')
          .doc(category.key)
          .set(category.toJson(), SetOptions(merge: true));
    } catch (exception, stackTrace) {
      _loggerService.error('Error creating or updating category: $exception',
          stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteCategory(CategoryModel category) async {
    try {
      await _firestore.collection('posts').doc(category.key).delete();
    } catch (exception, stackTrace) {
      _loggerService.error('Error deleting category: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }
}
