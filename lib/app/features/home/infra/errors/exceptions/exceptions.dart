import 'package:equatable/equatable.dart';

class FetchHistoryCategoriesException extends Equatable implements Exception {
  final String? message;

  const FetchHistoryCategoriesException({this.message});

  @override
  List<Object?> get props => [message];

  @override
  bool get stringify => true;
}

class FetchGeographyCategoriesException extends Equatable implements Exception {
  final String? message;

  const FetchGeographyCategoriesException({this.message});

  @override
  List<Object?> get props => [message];

  @override
  bool get stringify => true;
}
