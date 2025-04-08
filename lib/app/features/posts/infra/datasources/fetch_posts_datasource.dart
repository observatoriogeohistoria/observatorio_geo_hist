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
      QuerySnapshot postsQuerySnapshot = await _firestore
          .collectionGroup('category_posts')
          .where('isPublished', isEqualTo: true)
          .get();

      List<PostModel> posts = [];

      for (final post in postsQuerySnapshot.docs) {
        final data = post.data() as Map<String, dynamic>;
        final fromJson = PostModel.fromJson(data);

        if (fromJson.categoryId == category.key && fromJson.areas.contains(category.areas.first)) {
          posts.add(fromJson.copyWith(category: category));
        }
      }

      return posts;
    } catch (exception) {
      _loggerService.error('Error fetching posts: $exception');
      throw const FetchPostsException();
    }
  }
}
