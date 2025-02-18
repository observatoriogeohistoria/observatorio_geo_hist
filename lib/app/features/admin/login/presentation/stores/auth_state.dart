import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({
    required User? user,
    required LoginState loginState,
    required LogoutState logoutState,
  }) = _AuthState;

  LoginState get authLoginState => loginState;
  LogoutState get authLogoutState => logoutState;
}

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = LoginStateInitial;
  const factory LoginState.loading() = LoginStateLoading;
  const factory LoginState.success() = LoginStateSuccess;
  const factory LoginState.error(AuthFailure failure) = LoginStateError;
}

@freezed
class LogoutState with _$LogoutState {
  const factory LogoutState.initial() = LogoutStateInitial;
  const factory LogoutState.loading() = LogoutStateLoading;
  const factory LogoutState.success() = LogoutStateSuccess;
  const factory LogoutState.error(AuthFailure failure) = LogoutStateError;
}
