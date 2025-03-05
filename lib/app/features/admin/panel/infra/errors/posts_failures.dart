import 'package:observatorio_geo_hist/app/core/errors/failures.dart';

class GetPostsFailure extends Failure {
  const GetPostsFailure({
    String? message,
  }) : super("Erro ao buscar posts${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}

class CreatePostFailure extends Failure {
  const CreatePostFailure({
    String? message,
  }) : super("Erro ao criar post${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}

class UpdatePostFailure extends Failure {
  const UpdatePostFailure({
    String? message,
  }) : super("Erro ao atualizar post${message != null ? ": $message" : ""}");

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
