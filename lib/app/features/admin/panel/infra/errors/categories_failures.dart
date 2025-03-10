import 'package:observatorio_geo_hist/app/core/errors/failures.dart';

class GetCategoriesFailure extends Failure {
  const GetCategoriesFailure({
    String? message,
  }) : super("Erro ao buscar categorias${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}

class CreateOrUpdateCategoryFailure extends Failure {
  const CreateOrUpdateCategoryFailure({
    String? message,
  }) : super("Erro ao criar ou atualizar categoria${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}

class DeleteCategoryFailure extends Failure {
  const DeleteCategoryFailure({
    String? message,
  }) : super("Erro ao deletar categoria${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}
