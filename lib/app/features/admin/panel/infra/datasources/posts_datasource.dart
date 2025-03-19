import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/generator/id_generator.dart';

abstract class PostsDatasource {
  Future<List<PostModel>> getPosts();
  Future<PostModel> createOrUpdatePost(PostModel post);
  Future<void> deletePost(PostModel post);
}

class PostsDatasourceImpl implements PostsDatasource {
  final FirebaseFirestore _firestore;
  final LoggerService _loggerService;

  PostsDatasourceImpl(this._firestore, this._loggerService);

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      List<PostModel> posts = [];
      Set<CategoryModel> categories = {};

      // Get all areas and categories inside 'posts' collection
      QuerySnapshot areasSnapshot = await _firestore.collection('posts').get();

      for (var doc in areasSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final categoriesData = data['categories'] as List<dynamic>;

        categories.addAll(categoriesData.map((category) {
          return CategoryModel.fromJson(category, doc.id);
        }).toList());
      }

      // Get all posts from each category in each area in parallel
      final categoriesKeys = categories.map((category) => category.key).toSet();
      List<Future<QuerySnapshot>> postQueries = categoriesKeys.map((category) {
        return _firestore.collectionGroup(category).get();
      }).toList();

      List<QuerySnapshot> postSnapshots = await Future.wait(postQueries);

      // Process each post
      for (var postsSnapshot in postSnapshots) {
        for (var postDoc in postsSnapshot.docs) {
          Map<String, dynamic> data = postDoc.data() as Map<String, dynamic>;

          PostModel post = PostModel.fromJson({
            ...data,
            'id': postDoc.id,
            'category': categories
                .firstWhere((category) =>
                    category.key == postDoc.reference.parent.id &&
                    category.area.key == postDoc.reference.path.split('/')[1])
                .toJson(),
          });

          posts.add(post);
        }
      }

      posts.sort((a, b) => b.date.compareTo(a.date));

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
          .doc(newPost.area.key)
          .collection(newPost.category.key)
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
          .doc(post.area.key)
          .collection(post.category.key)
          .doc(post.id);

      await ref.delete();
    } catch (exception, stackTrace) {
      _loggerService.error('Error deleting post: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }
}
