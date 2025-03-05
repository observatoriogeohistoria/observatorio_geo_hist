import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/datasources/firebase_auth_datasource.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/datasources/posts/posts_datasource.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/datasources/users/users_datasource.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/repositories/posts/posts_repository.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/repositories/users/users_repository.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/posts_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/users_store.dart';

class PanelSetup {
  static final GetIt getIt = GetIt.instance;

  static void setup() {
    /// Users
    getIt.registerFactory<UsersDatasource>(
      () => UsersDatasourceImpl(
          getIt<FirebaseAuthDatasource>(), getIt<FirebaseFirestore>(), getIt<LoggerService>()),
    );
    getIt.registerFactory<UsersRepository>(
      () => UsersRepositoryImpl(getIt<UsersDatasource>()),
    );
    getIt.registerLazySingleton<UsersStore>(
      () => UsersStore(getIt<UsersRepository>()),
    );

    /// Posts
    getIt.registerFactory<PostsDatasource>(
      () => PostsDatasourceImpl(getIt<FirebaseFirestore>(), getIt<LoggerService>()),
    );
    getIt.registerFactory<PostsRepository>(
      () => PostsRepositoryImpl(getIt<PostsDatasource>()),
    );
    getIt.registerLazySingleton<PostsStore>(
      () => PostsStore(getIt<PostsRepository>()),
    );
  }
}
