// ignore_for_file: overridden_fields

import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/repositories/users_repository.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/crud_store.dart';
import 'package:observatorio_geo_hist/app/core/models/states/crud_states.dart';

part 'users_store.g.dart';

class UsersStore = UsersStoreBase with _$UsersStore;

abstract class UsersStoreBase extends CrudStore<UserModel> with Store {
  final UsersRepository _usersRepository;

  UsersStoreBase(this._usersRepository);

  @override
  @observable
  ObservableList<UserModel> items = ObservableList<UserModel>();

  @override
  @observable
  CrudState state = CrudInitialState();

  @override
  @action
  Future<void> getItems() async {
    if (state is CrudLoadingState) return;
    if (items.isNotEmpty) return;

    state = CrudLoadingState();

    final result = await _usersRepository.getUsers();

    result.fold(
      (failure) => state = CrudErrorState(failure),
      (users) {
        items = users.asObservable();
        state = CrudSuccessState();
      },
    );
  }

  @override
  @action
  Future<void> createOrUpdateItem(UserModel item, {dynamic extra}) async {
    state = CrudLoadingState(isRefreshing: true);

    bool isCreating = extra == null && extra is String;

    final result = isCreating
        ? await _usersRepository.createUser(item, extra)
        : await _usersRepository.updateUser(item);

    result.fold(
      (failure) => state = CrudErrorState(failure),
      (data) {
        final index = items.indexWhere((u) => u.id == data.id);
        index >= 0 ? items.replaceRange(index, index + 1, [data]) : items.add(data);

        state = CrudSuccessState(
            message: 'Usuário ${isCreating ? 'criado' : 'atualizado'} com sucesso');
      },
    );
  }

  @override
  @action
  Future<void> deleteItem(UserModel item) async {
    final result = await _usersRepository.deleteUser(item);

    result.fold(
      (failure) => state = CrudErrorState(failure),
      (_) {
        items.removeWhere((u) => u.id == item.id);
        state = CrudSuccessState(message: 'Usuário deletado com sucesso');
      },
    );
  }
}
