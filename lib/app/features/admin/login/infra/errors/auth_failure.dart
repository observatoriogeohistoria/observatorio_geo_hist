import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_failure.freezed.dart';

@freezed
class AuthFailure with _$AuthFailure {
  const factory AuthFailure.invalidCredentials() = InvalidCredentials;
  const factory AuthFailure.invalidEmail() = InvalidEmailAddress;
  const factory AuthFailure.userDisabled() = UserDisabled;
  const factory AuthFailure.userNotFound() = UserNotFound;
  const factory AuthFailure.wrongPassword() = WrongPassword;
  const factory AuthFailure.tooManyRequests() = TooManyRequests;
  const factory AuthFailure.emailAlreadyInUse() = EmailAlreadyInUse;
  const factory AuthFailure.serverError() = ServerError;

  static String toMessage(
    AuthFailure failure,
  ) {
    return failure.map(
      invalidCredentials: (_) => "Credenciais inválidas",
      invalidEmail: (_) => "E-mail inválido",
      userDisabled: (_) => "Usuário desabilitado",
      userNotFound: (_) => "Usuário não encontrado",
      wrongPassword: (_) => "Senha incorreta",
      tooManyRequests: (_) => "Muitas tentativas, tente novamente mais tarde",
      emailAlreadyInUse: (_) => "E-mail já está em uso",
      serverError: (_) => "Erro no servidor",
    );
  }
}
