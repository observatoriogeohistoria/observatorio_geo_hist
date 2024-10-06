import 'package:equatable/equatable.dart';

class FetchTeamException extends Equatable implements Exception {
  final String? message;

  const FetchTeamException({this.message});

  @override
  List<Object?> get props => [message];

  @override
  bool get stringify => true;
}
