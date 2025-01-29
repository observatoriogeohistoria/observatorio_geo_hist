import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/features/posts/infra/datasources/fetch_posts_datasource.dart';
import 'package:observatorio_geo_hist/app/features/posts/infra/repositories/fetch_posts_repository.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/stores/fetch_posts_store.dart';

class PostsSetup {
  static final GetIt getIt = GetIt.instance;

  static void setup() {
    // Fetch Posts
    getIt.registerFactory<FetchPostsDatasource>(
      () => FetchPostsDatasourceImpl(getIt<FirebaseFirestore>(), getIt<LoggerService>()),
    );
    getIt.registerFactory<FetchPostsRepository>(
      () => FetchPostsRepositoryImpl(getIt<FetchPostsDatasource>()),
    );
    getIt.registerLazySingleton<FetchPostsStore>(
      () => FetchPostsStore(getIt<FetchPostsRepository>()),
    );
  }
}
