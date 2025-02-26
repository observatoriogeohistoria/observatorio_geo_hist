import 'package:firebase_auth/firebase_auth.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';

class AuthFailure extends Failure {
  const AuthFailure([
    super.message = "Ocorreu um erro inesperado. Tente novamente mais tarde.",
  ]);

  @override
  List<Object> get props => [message];

  static AuthFailure fromException(
    FirebaseAuthException exception,
  ) {
    switch (exception.code.toLowerCase()) {
      case 'invalid-credential':
        return const InvalidCredentials();
      case 'invalid-email':
        return const InvalidEmailAddress();
      case 'user-disabled':
        return const UserDisabled();
      case 'user-not-found':
        return const UserNotFound();
      case 'wrong-password':
        return const WrongPassword();
      case 'too-many-requests':
        return const TooManyRequests();
      case 'email-already-in-use':
        return const EmailAlreadyInUse();
      case 'permission-denied':
        return const Forbidden();
      default:
        return const ServerError();
    }
  }
}

class InvalidCredentials extends AuthFailure {
  const InvalidCredentials() : super("Credenciais inválidas");
}

class InvalidEmailAddress extends AuthFailure {
  const InvalidEmailAddress() : super("E-mail inválido");
}

class UserDisabled extends AuthFailure {
  const UserDisabled() : super("Usuário desabilitado");
}

class UserNotFound extends AuthFailure {
  const UserNotFound() : super("Usuário não encontrado");
}

class WrongPassword extends AuthFailure {
  const WrongPassword() : super("Senha incorreta");
}

class TooManyRequests extends AuthFailure {
  const TooManyRequests() : super("Muitas tentativas, tente novamente mais tarde");
}

class EmailAlreadyInUse extends AuthFailure {
  const EmailAlreadyInUse() : super("E-mail já está em uso");
}

class Forbidden extends AuthFailure {
  const Forbidden() : super("Acesso negado");
}

class ServerError extends AuthFailure {
  const ServerError() : super("Erro no servidor");
}
