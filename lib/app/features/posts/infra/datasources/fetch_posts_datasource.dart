import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/paginated/paginated_posts.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

/// Post inexistente ou não publicado: o site público trata como não encontrado.
class PostNotFoundException implements Exception {
  const PostNotFoundException();
}

abstract class FetchPostsDatasource {
  Future<PaginatedPosts> fetchPosts(
    CategoryModel category, {
    PostType? postType,
    String? searchText,
    DocumentSnapshot? startAfterDocument,
    int limit = 10,
  });
  Future<PostModel> fetchPostById(String postId);
}

class FetchPostsDatasourceImpl implements FetchPostsDatasource {
  final FirebaseFirestore _firestore;
  final LoggerService _loggerService;

  FetchPostsDatasourceImpl(this._firestore, this._loggerService);

  @override
  Future<PaginatedPosts> fetchPosts(
    CategoryModel category, {
    PostType? postType,
    String? searchText,
    DocumentSnapshot? startAfterDocument,
    int limit = 10,
  }) async {
    try {
      Query query = _firestore
          .collectionGroup('category_posts')
          .where('isPublished', isEqualTo: true)
          .where('categoryId', isEqualTo: category.key)
          .where('areas', arrayContains: category.areas.first.key);

      if (postType != null) {
        query = query.where('type', isEqualTo: postType.name);
      }

      if (searchText != null && searchText.isNotEmpty) {
        final normalizedSearch = searchText.toLowerCase();
        query = query
            .orderBy('body.title_lower')
            .startAt([normalizedSearch]).endAt(['$normalizedSearch\uf8ff']);
      } else {
        query = query.orderBy('createdAt', descending: true);

        if (startAfterDocument != null) {
          query = query.startAfterDocument(startAfterDocument);
        }
      }

      query = query.limit(limit);

      final snapshot = await query.get();

      final posts = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final fromJson = PostModel.fromJson(data);

        return fromJson.copyWith(category: category);
      }).toList();

      return PaginatedPosts(
        posts: posts,
        lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
        hasMore: snapshot.docs.length == limit,
      );
    } catch (exception) {
      _loggerService.error('Error fetching posts: $exception');
      rethrow;
    }
  }

  @override
  Future<PostModel> fetchPostById(String postId) async {
    try {
      Query query =
          _firestore.collectionGroup('category_posts').where('id', isEqualTo: postId).limit(1);

      final snapshot = await query.get();
      if (snapshot.docs.isEmpty) throw const PostNotFoundException();

      final data = snapshot.docs.first.data() as Map<String, dynamic>;
      if (data['isPublished'] != true) throw const PostNotFoundException();

      return PostModel.fromJson(data);
    } on PostNotFoundException {
      rethrow;
    } catch (exception) {
      _loggerService.error('Error fetching post by id: $exception');
      rethrow;
    }
  }
}
