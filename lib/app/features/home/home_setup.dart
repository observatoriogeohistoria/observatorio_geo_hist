import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/datasources/fetch_team_datasource.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/repositories/fetch_team_repository.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/stores/fetch_team_store.dart';

class HomeSetup {
  static final GetIt getIt = GetIt.instance;

  static void setup() {
    // Fetch Team
    getIt.registerFactory<FetchTeamDatasource>(
      () => FetchTeamDatasourceImpl(getIt<FirebaseFirestore>(), getIt<LoggerService>()),
    );
    getIt.registerFactory<FetchTeamRepository>(
      () => FetchTeamRepositoryImpl(getIt<FetchTeamDatasource>()),
    );
    getIt.registerLazySingleton<FetchTeamStore>(
      () => FetchTeamStore(getIt<FetchTeamRepository>()),
    );
  }
}
