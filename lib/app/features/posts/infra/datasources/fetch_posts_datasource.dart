import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/posts/infra/errors/exceptions.dart';

abstract class FetchPostsDatasource {
  Future<List<PostModel>> fetchPosts(CategoryModel category);
}

class FetchPostsDatasourceImpl implements FetchPostsDatasource {
  final FirebaseFirestore _firestore;
  final LoggerService _loggerService;

  FetchPostsDatasourceImpl(this._firestore, this._loggerService);

  @override
  Future<List<PostModel>> fetchPosts(CategoryModel category) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('posts/${category.area.key}/${category.key}')
          .where('published', isEqualTo: true)
          .get();

      final docs = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        data['category'] = category.toJson();

        return data;
      }).toList();

      List<PostModel> posts = docs.map((post) => PostModel.fromJson(post)).toList();

      return posts;
    } catch (exception) {
      _loggerService.error('Error fetching geography categories: $exception');
      throw const FetchPostsException();
    }
  }
}
