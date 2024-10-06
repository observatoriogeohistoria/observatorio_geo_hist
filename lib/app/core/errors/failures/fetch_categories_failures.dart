import 'package:observatorio_geo_hist/app/core/errors/failures/failures.dart';

class FetchCategoriesFailure extends Failure {
  const FetchCategoriesFailure(
    String? message,
  ) : super("Erro ao buscar categorias${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}
