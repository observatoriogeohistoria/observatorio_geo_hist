import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/datasources/firebase_auth_datasource.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/datasources/categories_datasource.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/datasources/media_datasource.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/datasources/posts_datasource.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/datasources/team_datasource.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/datasources/users_datasource.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/repositories/categories_repository.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/repositories/media_repository.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/repositories/posts_repository.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/repositories/team_repository.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/repositories/users_repository.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/categories_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/media_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/posts_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/team_store.dart';
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

    /// Categories
    getIt.registerFactory<CategoriesDatasource>(
      () => CategoriesDatasourceImpl(getIt<FirebaseFirestore>(), getIt<LoggerService>()),
    );
    getIt.registerFactory<CategoriesRepository>(
      () => CategoriesRepositoryImpl(getIt<CategoriesDatasource>()),
    );
    getIt.registerLazySingleton<CategoriesStore>(
      () => CategoriesStore(getIt<CategoriesRepository>()),
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

    /// Media
    getIt.registerFactory<MediaDatasource>(
      () => MediaDatasourceImpl(getIt<FirebaseStorage>(), getIt<LoggerService>()),
    );
    getIt.registerFactory<MediaRepository>(
      () => MediaRepositoryImpl(getIt<MediaDatasource>()),
    );
    getIt.registerLazySingleton<MediaStore>(
      () => MediaStore(getIt<MediaRepository>()),
    );

    /// Team
    getIt.registerFactory<TeamDatasource>(
      () => TeamDatasourceImpl(getIt<FirebaseFirestore>(), getIt<LoggerService>()),
    );
    getIt.registerFactory<TeamRepository>(
      () => TeamRepositoryImpl(getIt<TeamDatasource>()),
    );
    getIt.registerLazySingleton<TeamStore>(
      () => TeamStore(getIt<TeamRepository>()),
    );
  }
}
