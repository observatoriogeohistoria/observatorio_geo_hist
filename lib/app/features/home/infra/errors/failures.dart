import 'package:observatorio_geo_hist/app/core/errors/failures/failures.dart';

class FetchTeamFailure extends Failure {
  const FetchTeamFailure(
    String? message,
  ) : super("Erro ao buscar equipe${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}
