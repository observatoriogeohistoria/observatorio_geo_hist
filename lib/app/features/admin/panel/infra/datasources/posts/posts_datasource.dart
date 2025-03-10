import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

abstract class PostsDatasource {
  Future<List<PostModel>> getPosts();
  Future<void> createOrUpdatePost(PostModel post);
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
      List<String> areas = [];
      Set<String> categories = {};

      // Get all areas and categories inside 'posts' collection
      QuerySnapshot areasSnapshot = await _firestore.collection('posts').get();

      for (var areaDoc in areasSnapshot.docs) {
        String area = areaDoc.id;
        areas.add(area);

        var data = areaDoc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('categories')) {
          categories
              .addAll((data['categories'] as List).map((category) => category['key'] as String));
        }
      }

      // Get all posts from each category in each area in parallel
      List<Future<QuerySnapshot>> postQueries = categories.map((category) {
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
            'area': postDoc.reference.path.split('/')[1],
            'category': postDoc.reference.parent.id,
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
  Future<void> createOrUpdatePost(PostModel post) async {
    try {
      DocumentReference postRef =
          _firestore.collection('posts').doc(post.area.key).collection(post.category).doc(post.id);

      await postRef.set(post.toJson(), SetOptions(merge: true));
    } catch (exception, stackTrace) {
      _loggerService.error('Error creating post: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deletePost(PostModel post) async {
    try {
      DocumentReference postRef =
          _firestore.collection('posts').doc(post.area.key).collection(post.category).doc(post.id);

      await postRef.delete();
    } catch (exception, stackTrace) {
      _loggerService.error('Error deleting post: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }
}
