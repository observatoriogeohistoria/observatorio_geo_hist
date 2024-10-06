import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([
    super.message = "Ocorreu um erro inesperado. Tente novamente mais tarde.",
  ]);

  @override
  List<Object> get props => [message];
}
