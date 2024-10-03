import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:observatorio_geo_hist/app/app_setup.dart';
import 'package:observatorio_geo_hist/app/app_widget.dart';

final GetIt locator = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AppSetup.setup();
  runApp(const AppWidget());
}
