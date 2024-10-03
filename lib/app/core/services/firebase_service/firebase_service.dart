import 'package:firebase_core/firebase_core.dart';
import 'package:observatorio_geo_hist/firebase_options.dart';

abstract class FirebaseService {}

class FirebaseServiceImpl extends FirebaseService {
  FirebaseServiceImpl._singleton();
  static final FirebaseServiceImpl instance = FirebaseServiceImpl._singleton();

  factory FirebaseServiceImpl() {
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    return instance;
  }
}
