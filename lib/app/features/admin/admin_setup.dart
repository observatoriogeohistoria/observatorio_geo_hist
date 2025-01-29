import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/datasources/firebase_auth_datasource.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/repositories/auth_repository.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';

class AdminSetup {
  static final GetIt getIt = GetIt.instance;

  static void setup() {
    // Auth
    getIt.registerFactory<FirebaseAuthDatasource>(
      () => FirebaseAuthDatasourceImpl(getIt<FirebaseAuth>(), getIt<LoggerService>()),
    );
    getIt.registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(getIt<FirebaseAuthDatasource>()),
    );
    getIt.registerLazySingleton<AuthStore>(
      () => AuthStore(getIt<AuthRepository>()),
    );
  }
}
