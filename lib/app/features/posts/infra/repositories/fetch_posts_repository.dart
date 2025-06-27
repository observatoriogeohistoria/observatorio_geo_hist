import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/paginated/paginated_posts.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/posts/infra/datasources/fetch_posts_datasource.dart';
import 'package:observatorio_geo_hist/app/features/posts/infra/errors/failures.dart';

abstract class FetchPostsRepository {
  Future<Either<Failure, PaginatedPosts>> fetchPosts(
    CategoryModel category, {
    PostType? postType,
    String? searchText,
    DocumentSnapshot? startAfterDocument,
    int limit = 10,
  });
  Future<Either<Failure, PostModel>> fetchPostById(String postId);
}

class FetchPostsRepositoryImpl implements FetchPostsRepository {
  final FetchPostsDatasource _datasource;

  FetchPostsRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, PaginatedPosts>> fetchPosts(
    CategoryModel category, {
    PostType? postType,
    String? searchText,
    DocumentSnapshot? startAfterDocument,
    int limit = 10,
  }) async {
    try {
      final posts = await _datasource.fetchPosts(
        category,
        postType: postType,
        searchText: searchText,
        startAfterDocument: startAfterDocument,
        limit: limit,
      );

      return Right(posts);
    } catch (error) {
      return const Left(FetchPostsFailure());
    }
  }

  @override
  Future<Either<Failure, PostModel>> fetchPostById(String postId) async {
    try {
      final post = await _datasource.fetchPostById(postId);
      return Right(post);
    } catch (error) {
      return const Left(FetchPostByIdFailure());
    }
  }
}
