import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/paginated/paginated_posts.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/posts/infra/errors/exceptions.dart';

abstract class FetchPostsDatasource {
  Future<PaginatedPosts> fetchPosts(
    CategoryModel category, {
    PostType? postType,
    String? searchText,
    DocumentSnapshot? startAfterDocument,
    int limit = 10,
  });
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
      // Start building the query from the 'category_posts' collection group
      Query query = _firestore
          .collectionGroup('category_posts')
          .where('isPublished', isEqualTo: true)
          .where('categoryId', isEqualTo: category.key)
          .where('areas', arrayContains: category.areas.first.key);

      // Apply post type filter if provided
      if (postType != null) {
        query = query.where('type', isEqualTo: postType.name);
      }

      // Apply search filter if provided
      if (searchText != null && searchText.isNotEmpty) {
        final normalizedSearch = searchText.toLowerCase();
        query = query
            .orderBy('body.title_lower')
            .startAt([normalizedSearch]).endAt(['$normalizedSearch\uf8ff']);

        // Pagination using startAfter on title can be added here if needed
      } else {
        // Default sort by creation date
        query = query.orderBy('createdAt', descending: true);

        // Apply pagination using document snapshot
        if (startAfterDocument != null) {
          query = query.startAfterDocument(startAfterDocument);
        }
      }

      // Limit the number of results
      query = query.limit(limit);

      // Execute the query
      final snapshot = await query.get();

      // Convert documents to PostModel and attach the category
      final posts = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final fromJson = PostModel.fromJson(data);
        return fromJson.copyWith(category: category);
      }).toList();

      // Return paginated posts
      return PaginatedPosts(
        posts: posts,
        lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
        hasMore: snapshot.docs.length == limit,
      );
    } catch (exception) {
      _loggerService.error('Error fetching posts: $exception');
      throw const FetchPostsException();
    }
  }
}
