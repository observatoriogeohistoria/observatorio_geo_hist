import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/datasources/fetch_library_datasource.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/repositories/fetch_library_repository.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/stores/fetch_library_store.dart';

class LibrarySetup {
  static final GetIt getIt = GetIt.instance;

  static void setup() {
    // Fetch Library
    getIt.registerFactory<FetchLibraryDatasource>(
      () => FetchLibraryDatasourceImpl(getIt<FirebaseFirestore>(), getIt<LoggerService>()),
    );
    getIt.registerFactory<FetchLibraryRepository>(
      () => FetchLibraryRepositoryImpl(getIt<FetchLibraryDatasource>()),
    );
    getIt.registerLazySingleton<FetchLibraryStore>(
      () => FetchLibraryStore(getIt<FetchLibraryRepository>()),
    );
  }
}
