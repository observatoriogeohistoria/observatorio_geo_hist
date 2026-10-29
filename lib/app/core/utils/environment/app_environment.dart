import 'package:firebase_core/firebase_core.dart';
import 'package:observatorio_geo_hist/firebase_options_dev.dart' as dev_options;
import 'package:observatorio_geo_hist/firebase_options_prod.dart' as prod_options;

/// Without the define, falls back to [dev] so it never writes to production by accident.
enum AppEnvironment {
  dev,
  prod;

  static const String _value = String.fromEnvironment('APP_ENV', defaultValue: 'dev');

  static AppEnvironment get current {
    return _value == 'prod' ? AppEnvironment.prod : AppEnvironment.dev;
  }

  bool get isProd => this == AppEnvironment.prod;

  // The dev project has no Storage enabled; media and library files only exist in prod.
  bool get hasStorage => isProd;

  FirebaseOptions get firebaseOptions {
    switch (this) {
      case AppEnvironment.dev:
        return dev_options.DefaultFirebaseOptions.currentPlatform;
      case AppEnvironment.prod:
        return prod_options.DefaultFirebaseOptions.currentPlatform;
    }
  }
}
