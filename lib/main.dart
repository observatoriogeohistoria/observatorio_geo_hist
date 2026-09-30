import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get_it/get_it.dart';
import 'package:observatorio_geo_hist/app/app_setup.dart';
import 'package:observatorio_geo_hist/app/app_widget.dart';
import 'package:observatorio_geo_hist/app/core/utils/browser/semantic_links.dart';
import 'package:observatorio_geo_hist/app/core/utils/environment/app_environment.dart';

final GetIt locator = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: AppEnvironment.current.firebaseOptions,
  );

  AppSetup.setup();

  usePathUrlStrategy();
  preventSemanticLinkNavigation();
  runApp(const AppWidget());
}
