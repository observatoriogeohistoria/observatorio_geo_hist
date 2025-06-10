import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/paginated/paginated_posts.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/posts/infra/errors/exceptions.dart';

abstract class FetchPostsDatasource {
  Future<PaginatedPosts> fetchPosts(
    CategoryModel category, {
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
    String? searchText,
    DocumentSnapshot? startAfterDocument,
    int limit = 10,
  }) async {
    try {
      /// Build the base query from the 'category_posts' collection group
      Query query = _firestore
          .collectionGroup('category_posts')
          .where('isPublished', isEqualTo: true)
          .where('categoryId', isEqualTo: category.key)
          .where('areas', arrayContains: category.areas.first.key);

      /// If searchText is provided, filter by title using prefix match
      if (searchText != null && searchText.isNotEmpty) {
        final normalizedSearch = searchText.toLowerCase();
        query = query
            .orderBy('body.title_lower')
            .startAt([normalizedSearch]).endAt(['$normalizedSearch\uf8ff']);

        /// Apply pagination based on title_lower
        // if (startAfterDocument != null) {
        //   final previousTitle =
        //       (startAfterDocument.data() as Map<String, dynamic>)['body']['title_lower'];
        //   query = query.startAfter([previousTitle]);
        // }
      } else {
        /// Default sorting by creation date
        query = query.orderBy('createdAt', descending: true);

        /// Apply pagination using the document snapshot
        // if (startAfterDocument != null) {
        //   query = query.startAfterDocument(startAfterDocument);
        // }
      }

      /// Limit the number of results
      // query = query.limit(limit);

      /// Fetch the documents
      QuerySnapshot postsQuerySnapshot = await query.get();

      /// Map the documents to PostModel and attach the category
      List<PostModel> posts = postsQuerySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final fromJson = PostModel.fromJson(data);
        return fromJson.copyWith(category: category);
      }).toList();

      /// Return the paginated posts
      return PaginatedPosts(
        posts: posts,
        lastDocument: postsQuerySnapshot.docs.isNotEmpty ? postsQuerySnapshot.docs.last : null,
        hasMore: postsQuerySnapshot.docs.length == limit,
      );
    } catch (exception) {
      _loggerService.error('Error fetching posts: $exception');
      throw const FetchPostsException();
    }
  }
}
