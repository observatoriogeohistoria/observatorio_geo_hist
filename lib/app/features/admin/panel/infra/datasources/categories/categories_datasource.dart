import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';

abstract class CategoriesDatasource {
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel> createOrUpdateCategory(CategoryModel category);
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

      Set<CategoryModel> categoriesSet = {};
      List<CategoryModel> categoriesList = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final categoriesData = data['categories'] as List<dynamic>;

        categoriesSet.addAll(categoriesData.map((category) {
          return CategoryModel.fromJson(category, doc.id);
        }).toList());
      }

      for (var category in categoriesSet) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('posts')
            .doc(category.area.key)
            .collection(category.key)
            .get();
        categoriesList.add(category.copyWith(numberOfPosts: querySnapshot.docs.length));
      }

      return categoriesList;
    } catch (exception, stackTrace) {
      _loggerService.error('Error fetching categories: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<CategoryModel> createOrUpdateCategory(CategoryModel category) async {
    try {
      DocumentReference ref = _firestore.collection('posts').doc(category.area.key);

      await ref.set({
        'categories': FieldValue.arrayUnion([category.toJson()])
      }, SetOptions(merge: true));

      return category;
    } catch (exception, stackTrace) {
      _loggerService.error('Error creating or updating category: $exception',
          stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteCategory(CategoryModel category) async {
    try {
      DocumentReference ref = _firestore.collection('posts').doc(category.area.key);

      DocumentSnapshot docSnapshot = await ref.get();
      QuerySnapshot querySnapshot = await ref.collection(category.key).get();

      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

      if (data.containsKey('categories')) {
        List categories = List.from(data['categories']);
        categories.removeWhere((item) => item['key'] == category.key);

        await ref.set({'categories': categories}, SetOptions(merge: true));
      }

      List<Future<void>> deletePosts =
          querySnapshot.docs.map((doc) => doc.reference.delete()).toList();
      await Future.wait(deletePosts);
    } catch (exception, stackTrace) {
      _loggerService.error('Error deleting category: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }
}
