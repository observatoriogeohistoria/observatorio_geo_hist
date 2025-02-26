// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UsersStore on UsersStoreBase, Store {
  late final _$usersAtom = Atom(name: 'UsersStoreBase.users', context: context);

  @override
  ObservableList<UserModel> get users {
    _$usersAtom.reportRead();
    return super.users;
  }

  @override
  set users(ObservableList<UserModel> value) {
    _$usersAtom.reportWrite(value, super.users, () {
      super.users = value;
    });
  }

  late final _$stateAtom = Atom(name: 'UsersStoreBase.state', context: context);

  @override
  ManageUsersState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(ManageUsersState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$getUsersAsyncAction =
      AsyncAction('UsersStoreBase.getUsers', context: context);

  @override
  Future<void> getUsers({bool emitLoading = true}) {
    return _$getUsersAsyncAction
        .run(() => super.getUsers(emitLoading: emitLoading));
  }

  late final _$createUserAsyncAction =
      AsyncAction('UsersStoreBase.createUser', context: context);

  @override
  Future<void> createUser(UserModel user, String password) {
    return _$createUserAsyncAction.run(() => super.createUser(user, password));
  }

  late final _$deleteUserAsyncAction =
      AsyncAction('UsersStoreBase.deleteUser', context: context);

  @override
  Future<void> deleteUser(UserModel user) {
    return _$deleteUserAsyncAction.run(() => super.deleteUser(user));
  }

  @override
  String toString() {
    return '''
users: ${users},
state: ${state}
    ''';
  }
}
