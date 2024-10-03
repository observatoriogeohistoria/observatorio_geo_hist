import 'package:firebase_core/firebase_core.dart';

abstract class FirebaseService {}

class FirebaseServiceImpl {
  FirebaseServiceImpl._singleton();
  static final FirebaseServiceImpl instance = FirebaseServiceImpl._singleton();

  factory FirebaseServiceImpl(FirebaseOptions options) {
    Firebase.initializeApp(options: options);
    return instance;
  }
}
