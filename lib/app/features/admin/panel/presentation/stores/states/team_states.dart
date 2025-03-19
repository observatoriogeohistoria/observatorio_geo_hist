import 'package:equatable/equatable.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';

sealed class ManageTeamState extends Equatable {
  @override
  List<Object> get props => [];
}

final class ManageTeamInitialState extends ManageTeamState {}

final class ManageTeamLoadingState extends ManageTeamState {}

final class ManageTeamSuccessState extends ManageTeamState {
  final String message;
  ManageTeamSuccessState({this.message = ''});
}

final class ManageTeamErrorState extends ManageTeamState {
  final Failure failure;
  ManageTeamErrorState(this.failure);
}
