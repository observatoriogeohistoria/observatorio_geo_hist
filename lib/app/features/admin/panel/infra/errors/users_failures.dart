import 'package:observatorio_geo_hist/app/core/errors/failures.dart';

class GetUsersFailure extends Failure {
  const GetUsersFailure({
    String? message,
  }) : super("Erro ao buscar usuários${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}

class CreateOrUpdateUserFailure extends Failure {
  const CreateOrUpdateUserFailure({
    String? message,
  }) : super("Erro ao criar ou atualizar usuário${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}

class DeleteUserFailure extends Failure {
  const DeleteUserFailure({
    String? message,
  }) : super("Erro ao deletar usuário${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}
