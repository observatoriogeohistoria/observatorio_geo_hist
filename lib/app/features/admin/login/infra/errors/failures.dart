import 'package:observatorio_geo_hist/app/core/errors/failures/failures.dart';

class SignInFailure extends Failure {
  const SignInFailure(
    String? message,
  ) : super("Erro ao fazer login${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}

class SignOutFailure extends Failure {
  const SignOutFailure(
    String? message,
  ) : super("Erro ao fazer logout${message != null ? ": $message" : ""}");

  @override
  List<Object> get props => [message];
}
