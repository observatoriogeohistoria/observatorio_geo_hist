import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observatorio_geo_hist/app/core/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/errors/exceptions/exceptions.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/navbutton_category_model.dart';

abstract class FetchNavButtonsCategoriesDatasource {
  Future<List<NavButtonCategoryModel>> fetchHistoryCategories();
  Future<List<NavButtonCategoryModel>> fetchGeographyCategories();
}

class FetchNavButtonsCategoriesDatasourceImpl implements FetchNavButtonsCategoriesDatasource {
  final FirebaseFirestore _firestore;
  final LoggerService _loggerService;

  FetchNavButtonsCategoriesDatasourceImpl(this._firestore, this._loggerService);

  @override
  Future<List<NavButtonCategoryModel>> fetchHistoryCategories() async {
    try {
      DocumentSnapshot categoriesSnapshot =
          await _firestore.collection('posts').doc('historia').get();

      if (categoriesSnapshot.data() == null) return [];

      Map<String, dynamic> categoriesData = categoriesSnapshot.data() as Map<String, dynamic>;
      List<NavButtonCategoryModel> categories = (categoriesData['categories'] as List)
          .map((category) => NavButtonCategoryModel.fromJson(category as Map<String, dynamic>))
          .toList();

      return categories;
    } catch (exception) {
      _loggerService.error('Error fetching history categories: $exception');
      throw const FetchHistoryCategoriesException();
    }
  }

  @override
  Future<List<NavButtonCategoryModel>> fetchGeographyCategories() async {
    try {
      DocumentSnapshot categoriesSnapshot =
          await _firestore.collection('posts').doc('geografia').get();

      if (categoriesSnapshot.data() == null) return [];

      Map<String, dynamic> categoriesData = categoriesSnapshot.data() as Map<String, dynamic>;
      List<NavButtonCategoryModel> categories = (categoriesData['categories'] as List)
          .map((category) => NavButtonCategoryModel.fromJson(category as Map<String, dynamic>))
          .toList();

      return categories;
    } catch (exception) {
      _loggerService.error('Error fetching geography categories: $exception');
      throw const FetchGeographyCategoriesException();
    }
  }
}
