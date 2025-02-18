import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';

abstract class FetchCategoriesDatasource {
  Future<List<CategoryModel>> fetchHistoryCategories();
  Future<List<CategoryModel>> fetchGeographyCategories();
}

class FetchCategoriesDatasourceImpl implements FetchCategoriesDatasource {
  final FirebaseFirestore _firestore;
  final LoggerService _loggerService;

  FetchCategoriesDatasourceImpl(this._firestore, this._loggerService);

  @override
  Future<List<CategoryModel>> fetchHistoryCategories() async {
    try {
      DocumentSnapshot categoriesSnapshot =
          await _firestore.collection('posts').doc('historia').get();

      if (categoriesSnapshot.data() == null) return [];

      Map<String, dynamic> categoriesData = categoriesSnapshot.data() as Map<String, dynamic>;
      List<CategoryModel> categories = (categoriesData['categories'] as List)
          .map(
            (category) => CategoryModel.fromJson(
              category as Map<String, dynamic>,
              'historia',
            ),
          )
          .toList();

      return categories;
    } catch (exception, stackTrace) {
      _loggerService.error('Error fetching history categories: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<CategoryModel>> fetchGeographyCategories() async {
    try {
      DocumentSnapshot categoriesSnapshot =
          await _firestore.collection('posts').doc('geografia').get();

      if (categoriesSnapshot.data() == null) return [];

      Map<String, dynamic> categoriesData = categoriesSnapshot.data() as Map<String, dynamic>;
      List<CategoryModel> categories = (categoriesData['categories'] as List)
          .map(
            (category) => CategoryModel.fromJson(
              category as Map<String, dynamic>,
              'geografia',
            ),
          )
          .toList();

      return categories;
    } catch (exception, stackTrace) {
      _loggerService.error('Error fetching geography categories: $exception',
          stackTrace: stackTrace);
      rethrow;
    }
  }
}
