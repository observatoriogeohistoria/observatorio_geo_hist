import 'package:flutter_modular/flutter_modular.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/services/firebase_service/firebase_service.dart';
import 'package:observatorio_geo_hist/app/modules/home/home_module.dart';

class AppModule extends Module {
  @override
  void exportedBinds(i) {
    // Logger
    // i.addLazySingleton<LoggerService>(LoggerServiceImpl.new);

    // Firebase
    i.addLazySingleton<FirebaseService>(FirebaseServiceImpl.new);
  }

  @override
  void routes(RouteManager r) {
    r.module(AppRoutes.root, module: HomeModule());
  }
}
