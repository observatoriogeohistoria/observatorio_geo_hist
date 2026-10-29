import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:observatorio_geo_hist/app/core/infra/datasources/fetch_categories_datasource.dart';
import 'package:observatorio_geo_hist/app/core/infra/repositories/fetch_categories_repository.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/core/stores/fetch_categories_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/admin_setup.dart';
import 'package:observatorio_geo_hist/app/features/home/home_setup.dart';
import 'package:observatorio_geo_hist/app/features/library/library_setup.dart';
import 'package:observatorio_geo_hist/app/features/posts/posts_setup.dart';

class AppSetup {
  static final GetIt getIt = GetIt.instance;

  static void setup() {
    getIt.registerLazySingleton<LoggerService>(() => LoggerServiceImpl());

    getIt.registerFactory<FirebaseFirestore>(() => FirebaseFirestore.instance);
    getIt.registerFactory<FirebaseAuth>(() => FirebaseAuth.instance);
    getIt.registerFactory<FirebaseStorage>(() => FirebaseStorage.instance);

    getIt.registerFactory<FetchCategoriesDatasource>(
      () => FetchCategoriesDatasourceImpl(getIt<FirebaseFirestore>(), getIt<LoggerService>()),
    );
    getIt.registerFactory<FetchCategoriesRepository>(
      () => FetchCategoriesRepositoryImpl(getIt<FetchCategoriesDatasource>()),
    );
    getIt.registerLazySingleton<FetchCategoriesStore>(
      () => FetchCategoriesStore(getIt<FetchCategoriesRepository>()),
    );

    HomeSetup.setup();

    PostsSetup.setup();

    AdminSetup.setup();

    LibrarySetup.setup();
  }
}
