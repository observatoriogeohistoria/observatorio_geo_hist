import 'package:observatorio_geo_hist/app/core/errors/failures.dart';

class FetchLibraryFailure extends Failure {
  const FetchLibraryFailure({
    String? message,
  }) : super("Erro ao buscar biblioteca${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}

class FetchLibraryDocumentByIdFailure extends Failure {
  const FetchLibraryDocumentByIdFailure({
    String? message,
  }) : super("Erro ao buscar documento por id${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}
