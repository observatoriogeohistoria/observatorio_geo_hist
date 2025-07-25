import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/datasources/library_datasource.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/repositories/library_repository.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/stores/filter_documents_store.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/stores/library_store.dart';

class LibrarySetup {
  static final GetIt getIt = GetIt.instance;

  static void setup() {
    // Fetch Library
    getIt.registerFactory<LibraryDatasource>(
      () => LibraryDatasourceImpl(
        getIt<FirebaseFirestore>(),
        getIt<FirebaseStorage>(),
        getIt<LoggerService>(),
      ),
    );
    getIt.registerFactory<LibraryRepository>(
      () => LibraryRepositoryImpl(getIt<LibraryDatasource>()),
    );
    getIt.registerLazySingleton<LibraryStore>(
      () => LibraryStore(getIt<LibraryRepository>()),
    );
    getIt.registerLazySingleton<FilterDocumentsStore>(
      () => FilterDocumentsStore(),
    );
  }
}
