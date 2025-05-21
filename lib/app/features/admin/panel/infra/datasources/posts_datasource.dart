import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/generator/id_generator.dart';

abstract class PostsDatasource {
  Future<List<PostModel>> getPosts(PostType type);
  Future<PostModel> createOrUpdatePost(PostModel post);
  Future<void> deletePost(PostModel post);
}

class PostsDatasourceImpl implements PostsDatasource {
  final FirebaseFirestore _firestore;
  final LoggerService _loggerService;

  PostsDatasourceImpl(this._firestore, this._loggerService);

  @override
  Future<List<PostModel>> getPosts(PostType type) async {
    try {
      QuerySnapshot categoriesQuerySnapshot = await _firestore.collection('posts').get();

      List<CategoryModel> categories = categoriesQuerySnapshot.docs
          .map((category) => CategoryModel.fromJson(category.data() as Map<String, dynamic>))
          .toList();

      QuerySnapshot postsQuerySnapshot = await _firestore
          .collectionGroup('category_posts')
          .where('type', isEqualTo: type.name)
          .orderBy('createdAt', descending: true)
          .get();

      List<PostModel> posts = postsQuerySnapshot.docs.map((post) {
        final data = post.data() as Map<String, dynamic>;
        final fromJson = PostModel.fromJson(data);

        return fromJson.copyWith(
          category: categories.firstWhereOrNull(
            (category) => category.key == fromJson.categoryId,
          ),
        );
      }).toList();

      return posts;
    } catch (exception, stackTrace) {
      _loggerService.error('Error fetching posts: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<PostModel> createOrUpdatePost(PostModel post) async {
    try {
      final newPost = post.copyWith(id: post.id ?? IdGenerator.generate());

      DocumentReference ref = _firestore
          .collection('posts')
          .doc(newPost.categoryId)
          .collection('category_posts')
          .doc(newPost.id);

      await ref.set(newPost.toJson(), SetOptions(merge: true));

      return newPost;
    } catch (exception, stackTrace) {
      _loggerService.error('Error creating or updating post: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deletePost(PostModel post) async {
    try {
      if (post.id == null) throw Exception('Post ID is required');

      DocumentReference ref = _firestore
          .collection('posts')
          .doc(post.categoryId)
          .collection('category_posts')
          .doc(post.id);

      await ref.delete();
    } catch (exception, stackTrace) {
      _loggerService.error('Error deleting post: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }
}
