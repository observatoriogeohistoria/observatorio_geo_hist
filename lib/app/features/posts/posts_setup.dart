import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/features/posts/infra/datasources/fetch_posts_datasource.dart';
import 'package:observatorio_geo_hist/app/features/posts/infra/repositories/fetch_posts_repository.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/stores/post_detail_store.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/stores/posts_listing_store.dart';

class PostsSetup {
  static final GetIt getIt = GetIt.instance;

  static void setup() {
    getIt.registerFactory<FetchPostsDatasource>(
      () => FetchPostsDatasourceImpl(
        getIt<FirebaseFirestore>(),
        getIt<LoggerService>(),
      ),
    );
    getIt.registerFactory<FetchPostsRepository>(
      () => FetchPostsRepositoryImpl(getIt<FetchPostsDatasource>()),
    );
    getIt.registerFactory<PostDetailStore>(
      () => PostDetailStore(getIt<FetchPostsRepository>()),
    );
    getIt.registerFactory<PostsListingStore>(
      () => PostsListingStore(getIt<FetchPostsRepository>()),
    );
  }
}
