import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:observatorio_geo_hist/app/core/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/datasources/fetch_navbuttons_categories_datasource.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/repositories/fetch_navbuttons_categories_repository.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/stores/home_store.dart';

class HomeSetup {
  static final GetIt getIt = GetIt.instance;

  static void setup() {
    // Home
    getIt.registerLazySingleton<FetchNavButtonsCategoriesDatasource>(
      () => FetchNavButtonsCategoriesDatasourceImpl(
        getIt<FirebaseFirestore>(),
        getIt<LoggerService>(),
      ),
    );

    getIt.registerLazySingleton<FetchNavButtonsCategoriesRepository>(
      () => FetchNavButtonsCategoriesRepositoryImpl(
        getIt<FetchNavButtonsCategoriesDatasource>(),
      ),
    );

    getIt.registerLazySingleton<HomeStore>(
      () => HomeStore(
        getIt<FetchNavButtonsCategoriesRepository>(),
      ),
    );
  }
}
