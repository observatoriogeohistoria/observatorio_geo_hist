import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:observatorio_geo_hist/app/app_module.dart';
import 'package:observatorio_geo_hist/app/app_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    ),
  );
}
