import 'package:firebase_core/firebase_core.dart';
import 'package:observatorio_geo_hist/firebase_options_dev.dart' as dev_options;
import 'package:observatorio_geo_hist/firebase_options_prod.dart' as prod_options;

/// Ambiente do app, definido em tempo de build por `--dart-define=APP_ENV=dev|prod`.
///
/// Sem o define (ex.: `flutter run` local), cai em [dev] para nunca escrever
/// sem querer no Firebase de produção.
enum AppEnvironment {
  dev,
  prod;

  static const String _value = String.fromEnvironment('APP_ENV', defaultValue: 'dev');

  static AppEnvironment get current {
    return _value == 'prod' ? AppEnvironment.prod : AppEnvironment.dev;
  }

  bool get isProd => this == AppEnvironment.prod;

  FirebaseOptions get firebaseOptions {
    switch (this) {
      case AppEnvironment.dev:
        return dev_options.DefaultFirebaseOptions.currentPlatform;
      case AppEnvironment.prod:
        return prod_options.DefaultFirebaseOptions.currentPlatform;
    }
  }
}
