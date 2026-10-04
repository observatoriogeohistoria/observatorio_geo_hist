import 'package:observatorio_geo_hist/app/core/errors/failures.dart';

class FetchLibraryFailure extends Failure {
  const FetchLibraryFailure({
    String? message,
  }) : super("Erro ao buscar biblioteca${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}

class LibraryDocumentNotFoundFailure extends Failure {
  const LibraryDocumentNotFoundFailure() : super('Documento não encontrado');

  @override
  List<Object> get props => [message];
}

class CreateOrUpdateLibraryDocumentFailure extends Failure {
  const CreateOrUpdateLibraryDocumentFailure({
    String? message,
  }) : super("Erro ao criar ou atualizar documento${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}

class DeleteLibraryDocumentFailure extends Failure {
  const DeleteLibraryDocumentFailure({
    String? message,
  }) : super("Erro ao deletar documento${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}

class CountLibraryFailure extends Failure {
  const CountLibraryFailure({
    String? message,
  }) : super("Erro ao contar documentos da biblioteca${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}
