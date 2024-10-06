import 'package:fpdart/fpdart.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures/failures.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/features/posts/infra/datasources/fetch_posts_datasource.dart';
import 'package:observatorio_geo_hist/app/features/posts/infra/errors/exceptions.dart';
import 'package:observatorio_geo_hist/app/features/posts/infra/errors/failures.dart';
import 'package:observatorio_geo_hist/app/features/posts/infra/models/post_model.dart';

abstract class FetchPostsRepository {
  Future<Either<Failure, List<PostModel>>> fetchPosts(CategoryModel category);
}

class FetchPostsRepositoryImpl implements FetchPostsRepository {
  final FetchPostsDatasource _datasource;

  FetchPostsRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<PostModel>>> fetchPosts(CategoryModel category) async {
    try {
      final posts = await _datasource.fetchPosts(category);
      return Right(posts);
    } on FetchPostsException catch (error) {
      return Left(FetchPostsFailure(error.message));
    }
  }
}
