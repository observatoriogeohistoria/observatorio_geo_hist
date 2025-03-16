import 'package:observatorio_geo_hist/app/core/errors/failures.dart';

class GetMediaFailure extends Failure {
  const GetMediaFailure({
    String? message,
  }) : super("Erro ao buscar mídias${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}

class CreateOrUpdateMediaFailure extends Failure {
  const CreateOrUpdateMediaFailure({
    String? message,
  }) : super("Erro ao criar ou atualizar mídia${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}

class DeleteMediaFailure extends Failure {
  const DeleteMediaFailure({
    String? message,
  }) : super("Erro ao deletar mídia${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}
