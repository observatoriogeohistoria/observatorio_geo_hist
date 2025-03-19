import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/datasources/posts_datasource.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/errors/posts_failures.dart';

abstract class PostsRepository {
  Future<Either<Failure, List<PostModel>>> getPosts();
  Future<Either<Failure, PostModel>> createOrUpdatePost(PostModel post);
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
  Future<Either<Failure, PostModel>> createOrUpdatePost(PostModel post) async {
    try {
      final result = await _postsDatasource.createOrUpdatePost(post);
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
