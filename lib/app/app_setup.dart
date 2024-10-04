import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:observatorio_geo_hist/app/core/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/features/home/home_setup.dart';

class AppSetup {
  static final GetIt getIt = GetIt.instance;

  static void setup() {
    // Logger
    getIt.registerLazySingleton<LoggerService>(() => LoggerServiceImpl());

    // Firebase
    getIt.registerFactory<FirebaseFirestore>(() => FirebaseFirestore.instance);

    // Home
    HomeSetup.setup();
  }
}
