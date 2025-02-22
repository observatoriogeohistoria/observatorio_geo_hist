import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/repositories/users/users_repository.dart';

part 'users_store.g.dart';

class UsersStore = UsersStoreBase with _$UsersStore;

abstract class UsersStoreBase with Store {
  final UsersRepository _usersRepository;

  UsersStoreBase(this._usersRepository);

  @observable
  ObservableList<UserModel> users = ObservableList<UserModel>();

  @action
  Future<void> getUsers() async {
    final result = await _usersRepository.getUsers();

    result.fold(
      (failure) {},
      (users) => this.users = users.asObservable(),
    );
  }

  @action
  Future<void> createUser(UserModel user, String password) async {
    final result = await _usersRepository.createUser(user, password);

    result.fold(
      (failure) {},
      (_) => getUsers(),
    );
  }
}
