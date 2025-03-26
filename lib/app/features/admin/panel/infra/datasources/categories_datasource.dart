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

      List<CategoryModel> categories = querySnapshot.docs
          .map((category) => CategoryModel.fromJson(category.data() as Map<String, dynamic>))
          .toList();

      List<CategoryModel> updatedCategories = [];

      for (var category in categories) {
        QuerySnapshot postsQuerySnapshot = await _firestore
            .collection('posts')
            .doc(category.key)
            .collection('category_posts')
            .get();

        updatedCategories.add(category.copyWith(numberOfPosts: postsQuerySnapshot.docs.length));
      }

      return updatedCategories;
    } catch (exception, stackTrace) {
      _loggerService.error('Error fetching categories: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<CategoryModel> createOrUpdateCategory(CategoryModel category) async {
    try {
      DocumentReference ref = _firestore.collection('posts').doc(category.key);
      await ref.set(category.toJson(), SetOptions(merge: true));

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
      DocumentReference ref = _firestore.collection('posts').doc(category.key);
      await ref.delete();

      // DocumentSnapshot docSnapshot = await ref.get();
      // QuerySnapshot querySnapshot = await ref.collection(category.key).get();

      // Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

      // if (data.containsKey('categories')) {
      //   List categories = List.from(data['categories']);
      //   categories.removeWhere((item) => item['key'] == category.key);

      //   await ref.set({'categories': categories}, SetOptions(merge: true));
      // }

      // List<Future<void>> deletePosts =
      //     querySnapshot.docs.map((doc) => doc.reference.delete()).toList();
      // await Future.wait(deletePosts);
    } catch (exception, stackTrace) {
      _loggerService.error('Error deleting category: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }
}
