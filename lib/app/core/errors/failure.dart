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

class GetGeneralPhysicalActivitiesFailure extends Failure {
  const GetGeneralPhysicalActivitiesFailure([
    super.message = "Falha ao buscar atividades físicas.",
  ]);

  @override
  List<Object> get props => [message];
}

class GetGeneralNutritionsFailure extends Failure {
  const GetGeneralNutritionsFailure([
    super.message = "Falha ao buscar nutrições.",
  ]);

  @override
  List<Object> get props => [message];
}

class RegisterNewPhysicalActitivyFailure extends Failure {
  const RegisterNewPhysicalActitivyFailure([
    super.message = "Falha ao registrar nova atividade física.",
  ]);

  @override
  List<Object> get props => [message];
}

class RegisterNewNutritionFailure extends Failure {
  const RegisterNewNutritionFailure([
    super.message = "Falha ao registrar nova nutrição.",
  ]);

  @override
  List<Object> get props => [message];
}
