import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/repositories/users/users_repository.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/states/users_states.dart';

part 'users_store.g.dart';

class UsersStore = UsersStoreBase with _$UsersStore;

abstract class UsersStoreBase with Store {
  final UsersRepository _usersRepository;

  UsersStoreBase(this._usersRepository);

  @observable
  ObservableList<UserModel> users = ObservableList<UserModel>();

  @observable
  ManageUsersState state = ManageUsersInitialState();

  @action
  Future<void> getUsers() async {
    if (state is ManageUsersLoadingState) return;
    if (users.isNotEmpty) return;

    state = ManageUsersLoadingState();

    final result = await _usersRepository.getUsers();

    result.fold(
      (failure) => state = ManageUsersErrorState(failure),
      (users) {
        this.users = users.asObservable();
        state = ManageUsersSuccessState();
      },
    );
  }

  @action
  Future<void> createUser(UserModel user, String password) async {
    final result = await _usersRepository.createUser(user, password);

    result.fold(
      (failure) => state = ManageUsersErrorState(failure),
      (data) {
        final index = users.indexWhere((u) => u.id == data.id);
        index >= 0 ? users.replaceRange(index, index + 1, [data]) : users.add(data);

        state = ManageUsersSuccessState(message: 'Usuário criado com sucesso');
      },
    );
  }

  @action
  Future<void> updateUser(UserModel user) async {
    final result = await _usersRepository.updateUser(user);

    result.fold(
      (failure) => state = ManageUsersErrorState(failure),
      (data) {
        final index = users.indexWhere((u) => u.id == data.id);
        index >= 0 ? users.replaceRange(index, index + 1, [data]) : users.add(data);

        state = ManageUsersSuccessState(message: 'Usuário atualizado com sucesso');
      },
    );
  }

  @action
  Future<void> deleteUser(UserModel user) async {
    final result = await _usersRepository.deleteUser(user);

    result.fold(
      (failure) => state = ManageUsersErrorState(failure),
      (_) {
        users.removeWhere((u) => u.id == user.id);
        state = ManageUsersSuccessState(message: 'Usuário deletado com sucesso');
      },
    );
  }
}
