import 'package:observatorio_geo_hist/app/core/errors/failures.dart';

class FetchPostsFailure extends Failure {
  const FetchPostsFailure({String? message})
      : super("Erro ao buscar posts${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}

class CountPostsFailure extends Failure {
  const CountPostsFailure() : super("Erro ao contar posts");

  @override
  List<Object> get props => [message];
}

class FetchPostByIdFailure extends Failure {
  const FetchPostByIdFailure({String? message})
      : super("Erro ao buscar post por id${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}

class PostNotFoundFailure extends Failure {
  const PostNotFoundFailure() : super("Post não encontrado");

  @override
  List<Object> get props => [message];
}

class FetchHighlightsFailure extends Failure {
  const FetchHighlightsFailure({String? message})
      : super("Erro ao buscar destaques${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}
