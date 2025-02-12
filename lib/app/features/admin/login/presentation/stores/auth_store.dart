import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/repositories/auth_repository.dart';

part 'auth_store.g.dart';

class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  final AuthRepository _authRepository;

  AuthStoreBase(this._authRepository);

  @observable
  User? user;

  @observable
  bool passwordVisible = false;

  @action
  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
  }

  @action
  Future<void> login(String email, String password) async {
    final result = await _authRepository.login(email, password);

    result.fold(
      (failure) => print(failure.message),
      (user) => this.user = user,
    );
  }
}
