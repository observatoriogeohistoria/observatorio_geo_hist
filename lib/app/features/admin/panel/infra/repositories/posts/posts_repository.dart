import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/datasources/posts/posts_datasource.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/errors/posts_failures.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/post_model.dart';

abstract class PostsRepository {
  Future<Either<Failure, List<PostModel>>> getPosts();
  Future<Either<Failure, Unit>> createPost(PostModel post);
  Future<Either<Failure, Unit>> updatePost(PostModel post);
  Future<Either<Failure, Unit>> deletePost(PostModel post);
}

class PostsRepositoryImpl implements PostsRepository {
  final PostsDatasource _postsDatasource;

  PostsRepositoryImpl(this._postsDatasource);

  @override
  Future<Either<Failure, List<PostModel>>> getPosts() async {
    try {
      final posts = await _postsDatasource.getPosts();
      return Right(posts);
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure.fromException(error));
    } catch (error) {
      return const Left(GetPostsFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> createPost(PostModel post) async {
    try {
      await _postsDatasource.createPost(post);
      return const Right(unit);
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure.fromException(error));
    } catch (error) {
      return const Left(CreatePostFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePost(PostModel post) async {
    try {
      await _postsDatasource.updatePost(post);
      return const Right(unit);
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure.fromException(error));
    } catch (error) {
      return const Left(UpdatePostFailure());
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
