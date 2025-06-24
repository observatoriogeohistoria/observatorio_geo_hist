import 'package:observatorio_geo_hist/app/core/errors/failures.dart';

class FetchTeamFailure extends Failure {
  const FetchTeamFailure({
    String? message,
  }) : super("Erro ao buscar equipe${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}

class FetchHighlightsFailure extends Failure {
  const FetchHighlightsFailure({
    String? message,
  }) : super("Erro ao buscar destaque${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}
