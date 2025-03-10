import 'package:observatorio_geo_hist/app/core/errors/failures.dart';

class GetPostsFailure extends Failure {
  const GetPostsFailure({
    String? message,
  }) : super("Erro ao buscar posts${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}

class CreateOrUpdatePostFailure extends Failure {
  const CreateOrUpdatePostFailure({
    String? message,
  }) : super("Erro ao criar ou atualizar post${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}

class DeletePostFailure extends Failure {
  const DeletePostFailure({
    String? message,
  }) : super("Erro ao deletar post${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}
