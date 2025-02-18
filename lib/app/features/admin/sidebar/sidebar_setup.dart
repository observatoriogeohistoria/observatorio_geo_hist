import 'package:get_it/get_it.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/stores/sidebar_store.dart';

class SidebarSetup {
  static final GetIt getIt = GetIt.instance;

  static void setup() {
    // Sidebar Navigation
    getIt.registerLazySingleton<SidebarStore>(
      () => SidebarStore(),
    );
  }
}
