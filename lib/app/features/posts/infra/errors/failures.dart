import 'package:observatorio_geo_hist/app/core/errors/failures.dart';

class FetchPostsFailure extends Failure {
  const FetchPostsFailure(
    String? message,
  ) : super("Erro ao buscar posts${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}
