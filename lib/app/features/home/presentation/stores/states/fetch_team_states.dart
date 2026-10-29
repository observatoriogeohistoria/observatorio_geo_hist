import 'package:equatable/equatable.dart';

sealed class FetchTeamState extends Equatable {
  @override
  List<Object> get props => [];
}

final class FetchTeamInitialState extends FetchTeamState {}

final class FetchTeamLoadingState extends FetchTeamState {}

final class FetchTeamSuccessState extends FetchTeamState {}

final class FetchTeamErrorState extends FetchTeamState {
  final String message;
  FetchTeamErrorState(this.message);
}
