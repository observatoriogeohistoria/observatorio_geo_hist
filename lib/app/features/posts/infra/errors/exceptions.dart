import 'package:equatable/equatable.dart';

class FetchPostsException extends Equatable implements Exception {
  final String? message;

  const FetchPostsException({this.message});

  @override
  List<Object?> get props => [message];

  @override
  bool get stringify => true;
}
