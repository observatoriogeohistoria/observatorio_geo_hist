import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/paginated/paginated_posts.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/generator/id_generator.dart';

abstract class PostsDatasource {
  Future<PaginatedPosts> getPosts(
    PostType type, {
    String? searchText,
    PostsAreas? searchArea,
    CategoryModel? searchCategory,
    bool? isPublished,
    bool? isHighlighted,
    DocumentSnapshot? startAfterDocument,
    int limit = 10,
  });
  Future<PostModel> createOrUpdatePost(
    PostModel post,
    CategoryModel? pastCategory,
  );
  Future<void> deletePost(PostModel post);
}

class PostsDatasourceImpl implements PostsDatasource {
  final FirebaseFirestore _firestore;
  final LoggerService _loggerService;

  PostsDatasourceImpl(this._firestore, this._loggerService);

  @override
  Future<PaginatedPosts> getPosts(
    PostType type, {
    String? searchText,
    PostsAreas? searchArea,
    CategoryModel? searchCategory,
    bool? isPublished,
    bool? isHighlighted,
    DocumentSnapshot? startAfterDocument,
    int limit = 10,
  }) async {
    try {
      QuerySnapshot categoriesQuerySnapshot = await _firestore.collection('posts').get();

      List<CategoryModel> categories = categoriesQuerySnapshot.docs
          .map((category) => CategoryModel.fromJson(category.data() as Map<String, dynamic>))
          .toList();

      Query query = _firestore.collectionGroup('category_posts');

      if (searchArea != null) {
        query = query.where('areas', arrayContains: searchArea.key);
      }

      if (searchCategory != null) {
        query = query.where('categoryId', isEqualTo: searchCategory.key);
      }

      if (isPublished != null) {
        query = query.where('isPublished', isEqualTo: isPublished);
      }

      if (isHighlighted != null) {
        query = query.where('isHighlighted', isEqualTo: isHighlighted);
      }

      if (searchText != null && searchText.isNotEmpty) {
        query = query.where('type', isEqualTo: type.name).orderBy('body.title_lower').limit(limit);

        if (startAfterDocument != null) {
          final previousTitle =
              (startAfterDocument.data() as Map<String, dynamic>)['body']['title_lower'];
          query = query.startAfter([previousTitle]);
        }

        query = query.startAt([searchText]).endAt(['$searchText\uf8ff']);
      } else {
        query = query
            .where('type', isEqualTo: type.name)
            .orderBy('createdAt', descending: true)
            .limit(limit);

        if (startAfterDocument != null) {
          query = query.startAfterDocument(startAfterDocument);
        }
      }

      QuerySnapshot postsQuerySnapshot = await query.get();

      QueryDocumentSnapshot? lastDocument;
      if (postsQuerySnapshot.docs.isNotEmpty) {
        lastDocument = postsQuerySnapshot.docs.last;
      }

      List<PostModel> posts = postsQuerySnapshot.docs.map((post) {
        final data = post.data() as Map<String, dynamic>;
        final fromJson = PostModel.fromJson(data);

        return fromJson.copyWith(
          category: categories.firstWhereOrNull(
            (category) => category.key == fromJson.categoryId,
          ),
        );
      }).toList();

      return PaginatedPosts(
        posts: posts,
        lastDocument: lastDocument,
        hasMore: postsQuerySnapshot.docs.length == limit,
      );
    } catch (exception, stackTrace) {
      _loggerService.error('Error fetching posts: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<PostModel> createOrUpdatePost(
    PostModel post,
    CategoryModel? pastCategory,
  ) async {
    try {
      final newPost = post.copyWith(id: post.id ?? IdGenerator.generate());

      if (pastCategory != null && post.id != null) {
        DocumentReference ref = _firestore
            .collection('posts')
            .doc(pastCategory.key)
            .collection('category_posts')
            .doc(post.id);

        await ref.delete();
      }

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
