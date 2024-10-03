import 'package:flutter_modular/flutter_modular.dart';
import 'package:observatorio_geo_hist/app/app_module.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/modules/home/presentation/home_page.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports => [AppModule()];

  @override
  void binds(Injector i) {}

  @override
  void routes(r) {
    r.child(
      AppRoutes.root,
      child: (context) => const HomePage(),
    );
  }
}
