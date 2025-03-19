// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TeamStore on TeamStoreBase, Store {
  late final _$teamMembersAtom =
      Atom(name: 'TeamStoreBase.teamMembers', context: context);

  @override
  ObservableList<TeamMemberModel> get teamMembers {
    _$teamMembersAtom.reportRead();
    return super.teamMembers;
  }

  @override
  set teamMembers(ObservableList<TeamMemberModel> value) {
    _$teamMembersAtom.reportWrite(value, super.teamMembers, () {
      super.teamMembers = value;
    });
  }

  late final _$stateAtom = Atom(name: 'TeamStoreBase.state', context: context);

  @override
  ManageTeamState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(ManageTeamState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$getTeamMembersAsyncAction =
      AsyncAction('TeamStoreBase.getTeamMembers', context: context);

  @override
  Future<void> getTeamMembers() {
    return _$getTeamMembersAsyncAction.run(() => super.getTeamMembers());
  }

  late final _$createOrUpdateTeamMemberAsyncAction =
      AsyncAction('TeamStoreBase.createOrUpdateTeamMember', context: context);

  @override
  Future<void> createOrUpdateTeamMember(TeamMemberModel teamMember) {
    return _$createOrUpdateTeamMemberAsyncAction
        .run(() => super.createOrUpdateTeamMember(teamMember));
  }

  late final _$deleteTeamMemberAsyncAction =
      AsyncAction('TeamStoreBase.deleteTeamMember', context: context);

  @override
  Future<void> deleteTeamMember(TeamMemberModel teamMember) {
    return _$deleteTeamMemberAsyncAction
        .run(() => super.deleteTeamMember(teamMember));
  }

  @override
  String toString() {
    return '''
teamMembers: ${teamMembers},
state: ${state}
    ''';
  }
}
