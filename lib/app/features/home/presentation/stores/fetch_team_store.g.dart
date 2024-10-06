// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_team_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FetchTeamStore on FetchTeamStoreBase, Store {
  late final _$teamAtom =
      Atom(name: 'FetchTeamStoreBase.team', context: context);

  @override
  ObservableList<TeamMemberModel> get team {
    _$teamAtom.reportRead();
    return super.team;
  }

  @override
  set team(ObservableList<TeamMemberModel> value) {
    _$teamAtom.reportWrite(value, super.team, () {
      super.team = value;
    });
  }

  late final _$fetchTeamAsyncAction =
      AsyncAction('FetchTeamStoreBase.fetchTeam', context: context);

  @override
  Future<void> fetchTeam() {
    return _$fetchTeamAsyncAction.run(() => super.fetchTeam());
  }

  @override
  String toString() {
    return '''
team: ${team}
    ''';
  }
}
