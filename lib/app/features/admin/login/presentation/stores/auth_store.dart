import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/repositories/auth_repository.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_state.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';

part 'auth_store.g.dart';

class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  final AuthRepository _authRepository;

  AuthStoreBase(this._authRepository);

  @observable
  bool passwordVisible = false;

  @observable
  UserModel? user;

  @observable
  AuthState state = const AuthState(
    loginState: LoginState.initial(),
    logoutState: LogoutState.initial(),
  );

  @action
  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
  }

  @action
  Future<void> currentUser() async {
    final result = await _authRepository.currentUser();

    result.fold(
      (failure) => user = null,
      (user) => this.user = user,
    );
  }

  @action
  Future<void> login(String email, String password) async {
    state = state.copyWith(loginState: const LoginState.loading());

    final result = await _authRepository.login(email, password);

    result.fold(
      (failure) => state = state.copyWith(loginState: LoginState.error(failure)),
      (user) {
        this.user = user;

        state = state.copyWith(
          loginState: const LoginState.success(),
          logoutState: const LogoutState.initial(),
        );
      },
    );
  }

  @action
  Future<void> logout() async {
    state = state.copyWith(logoutState: const LogoutState.loading());

    final result = await _authRepository.logout();

    result.fold(
      (failure) => state = state.copyWith(logoutState: LogoutState.error(failure)),
      (_) {
        user = null;
        state = state.copyWith(
          loginState: const LoginState.initial(),
          logoutState: const LogoutState.success(),
        );
      },
    );
  }
}
