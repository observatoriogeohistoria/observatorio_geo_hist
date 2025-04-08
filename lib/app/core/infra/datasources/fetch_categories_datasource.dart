import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';

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
      QuerySnapshot querySnapshot = await _firestore
          .collection('posts')
          .where(
            'areas',
            arrayContains: 'historia',
          )
          .get();

      if (querySnapshot.docs.isEmpty) return [];

      List<CategoryModel> categories = querySnapshot.docs
          .map(
            (category) => CategoryModel.fromJson(
              category.data() as Map<String, dynamic>,
            ).copyWith(areas: [PostsAreas.history]),
          )
          .toList();

      categories.sort((a, b) => a.title.compareTo(b.title));

      return categories;
    } catch (exception, stackTrace) {
      _loggerService.error('Error fetching history categories: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<CategoryModel>> fetchGeographyCategories() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('posts')
          .where(
            'areas',
            arrayContains: 'geografia',
          )
          .get();

      if (querySnapshot.docs.isEmpty) return [];

      List<CategoryModel> categories = querySnapshot.docs
          .map(
            (category) => CategoryModel.fromJson(
              category.data() as Map<String, dynamic>,
            ).copyWith(areas: [PostsAreas.geography]),
          )
          .toList();

      categories.sort((a, b) => a.title.compareTo(b.title));

      return categories;
    } catch (exception, stackTrace) {
      _loggerService.error('Error fetching geography categories: $exception',
          stackTrace: stackTrace);
      rethrow;
    }
  }
}
