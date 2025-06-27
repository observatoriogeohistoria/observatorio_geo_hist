import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/models/paginated/paginated_posts.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/generator/id_generator.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/datasources/media_datasource.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/datasources/posts_datasource.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/errors/posts_failures.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/media_model.dart';

abstract class PostsRepository {
  Future<Either<Failure, PaginatedPosts>> getPosts(
    PostType type, {
    String? searchText,
    PostsAreas? searchArea,
    CategoryModel? searchCategory,
    bool? isPublished,
    bool? isHighlighted,
    DocumentSnapshot? startAfterDocument,
    int limit = 10,
  });
  Future<Either<Failure, PostModel>> createOrUpdatePost(
    PostModel post,
    CategoryModel? pastCategory,
  );
  Future<Either<Failure, Unit>> deletePost(PostModel post);
}

class PostsRepositoryImpl implements PostsRepository {
  final PostsDatasource _postsDatasource;
  final MediaDatasource _mediaDatasource;

  PostsRepositoryImpl(this._postsDatasource, this._mediaDatasource);

  @override
  Future<Either<Failure, PaginatedPosts>> getPosts(
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
      final posts = await _postsDatasource.getPosts(
        type,
        searchText: searchText,
        searchArea: searchArea,
        searchCategory: searchCategory,
        isPublished: isPublished,
        isHighlighted: isHighlighted,
        startAfterDocument: startAfterDocument,
        limit: limit,
      );

      return Right(posts);
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure.fromException(error));
    } catch (error) {
      return const Left(GetPostsFailure());
    }
  }

  @override
  Future<Either<Failure, PostModel>> createOrUpdatePost(
    PostModel post,
    CategoryModel? pastCategory,
  ) async {
    try {
      if (post.body?.image.bytes != null) {
        final name = post.body!.image.name ?? IdGenerator.generate();
        final hasExtension = name.contains('.');
        final extension = hasExtension ? name.split('.').last : '';
        final finalName = hasExtension ? name.split('.').first : name;

        final media = await _mediaDatasource.createMedia(
          MediaModel(
            name: finalName,
            extension: extension,
            bytes: post.body!.image.bytes!,
            url: post.body!.image.url,
          ),
        );

        post = post.copyWith(
          body: post.body!.copyWith(
            image: ImageModel(
              url: media.url,
              bytes: media.bytes,
              name: media.name,
            ),
          ),
        );
      }

      final result = await _postsDatasource.createOrUpdatePost(post, pastCategory);
      return Right(result);
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure.fromException(error));
    } catch (error) {
      return const Left(CreateOrUpdatePostFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePost(PostModel post) async {
    try {
      await _postsDatasource.deletePost(post);
      return const Right(unit);
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure.fromException(error));
    } catch (error) {
      return const Left(DeletePostFailure());
    }
  }
}
