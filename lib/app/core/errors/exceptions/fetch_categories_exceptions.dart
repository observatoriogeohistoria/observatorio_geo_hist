import 'package:equatable/equatable.dart';

class FetchCategoriesException extends Equatable implements Exception {
  final String? message;

  const FetchCategoriesException({this.message});

  @override
  List<Object?> get props => [message];

  @override
  bool get stringify => true;
}
