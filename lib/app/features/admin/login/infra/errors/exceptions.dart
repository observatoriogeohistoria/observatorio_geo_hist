import 'package:equatable/equatable.dart';

class FirebaseSignInException extends Equatable implements Exception {
  final String? message;

  const FirebaseSignInException({this.message});

  @override
  List<Object?> get props => [message];

  @override
  bool get stringify => true;
}

class FirebaseSignOutException extends Equatable implements Exception {
  final String? message;

  const FirebaseSignOutException({this.message});

  @override
  List<Object?> get props => [message];

  @override
  bool get stringify => true;
}
