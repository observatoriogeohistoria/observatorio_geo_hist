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
  /// Sem [category], busca em todas as categorias.
  Future<PaginatedPosts> fetchPosts(
    CategoryModel? category, {
    PostType? postType,
    String? searchText,
    DocumentSnapshot? startAfterDocument,
    int limit = 10,
  });
  Future<int> countPosts({
    CategoryModel? category,
    PostType? postType,
    String? searchText,
  });
  Future<PostModel> fetchPostById(String postId);
}

class FetchPostsDatasourceImpl implements FetchPostsDatasource {
  final FirebaseFirestore _firestore;
  final LoggerService _loggerService;

  FetchPostsDatasourceImpl(this._firestore, this._loggerService);

  // A contagem usa a mesma ordenação da lista para aproveitar os mesmos índices.
  Query _listingQuery(CategoryModel? category, PostType? postType, String? searchText) {
    Query query =
        _firestore.collectionGroup('category_posts').where('isPublished', isEqualTo: true);

    if (category != null) {
      query = query
          .where('categoryId', isEqualTo: category.key)
          .where('areas', arrayContains: category.areas.first.key);
    }

    if (postType != null) {
      query = query.where('type', isEqualTo: postType.name);
    }

    final normalizedSearch = searchText?.trim().toLowerCase() ?? '';
    if (normalizedSearch.isEmpty) return query.orderBy('createdAt', descending: true);

    return query
        .orderBy('body.title_lower')
        .startAt([normalizedSearch]).endAt(['$normalizedSearch\uf8ff']);
  }

  @override
  Future<PaginatedPosts> fetchPosts(
    CategoryModel? category, {
    PostType? postType,
    String? searchText,
    DocumentSnapshot? startAfterDocument,
    int limit = 10,
  }) async {
    try {
      Query query = _listingQuery(category, postType, searchText);

      if (startAfterDocument != null) {
        query = query.startAfterDocument(startAfterDocument);
      }

      // Um a mais diz se existe próxima página sem precisar de um clique que volte vazio.
      final snapshot = await query.limit(limit + 1).get();
      final hasMore = snapshot.docs.length > limit;
      final docs = hasMore ? snapshot.docs.sublist(0, limit) : snapshot.docs;

      final posts = docs.map((doc) {
        final post = PostModel.fromJson(doc.data() as Map<String, dynamic>);
        return category == null ? post : post.copyWith(category: category);
      }).toList();

      return PaginatedPosts(
        posts: posts,
        lastDocument: docs.isNotEmpty ? docs.last : null,
        hasMore: hasMore,
      );
    } catch (exception) {
      _loggerService.error('Error fetching posts: $exception');
      rethrow;
    }
  }

  @override
  Future<int> countPosts({
    CategoryModel? category,
    PostType? postType,
    String? searchText,
  }) async {
    try {
      final snapshot = await _listingQuery(category, postType, searchText).count().get();
      return snapshot.count ?? 0;
    } catch (exception) {
      _loggerService.error('Error counting posts: $exception');
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
