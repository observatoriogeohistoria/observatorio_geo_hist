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
  Future<void> getUsers({
    bool emitLoading = true,
  }) async {
    if (emitLoading) state = ManageUsersLoadingState();

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
    state = ManageUsersLoadingState();

    final result = await _usersRepository.createUser(user, password);

    result.fold(
      (failure) => state = ManageUsersErrorState(failure),
      (_) {
        getUsers(emitLoading: false);
        state = ManageUsersSuccessState();
      },
    );
  }

  @action
  Future<void> deleteUser(UserModel user) async {
    state = ManageUsersLoadingState();

    final result = await _usersRepository.deleteUser(user);

    result.fold(
      (failure) => state = ManageUsersErrorState(failure),
      (_) {
        getUsers(emitLoading: false);
        state = ManageUsersSuccessState();
      },
    );
  }
}
