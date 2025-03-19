import 'package:observatorio_geo_hist/app/core/errors/failures.dart';

class GetTeamMembersFailure extends Failure {
  const GetTeamMembersFailure({
    String? message,
  }) : super("Erro ao buscar membros da equipe${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}

class CreateOrUpdateTeamMemberFailure extends Failure {
  const CreateOrUpdateTeamMemberFailure({
    String? message,
  }) : super("Erro ao criar ou atualizar membro da equipe${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}

class DeleteTeamMemberFailure extends Failure {
  const DeleteTeamMemberFailure({
    String? message,
  }) : super("Erro ao deletar membro da equipe${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}
