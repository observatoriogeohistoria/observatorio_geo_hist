import 'package:equatable/equatable.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';

sealed class ManageUsersState extends Equatable {
  @override
  List<Object> get props => [];
}

final class ManageUsersInitialState extends ManageUsersState {}

final class ManageUsersLoadingState extends ManageUsersState {}

final class ManageUsersSuccessState extends ManageUsersState {}

final class ManageUsersErrorState extends ManageUsersState {
  final Failure failure;
  ManageUsersErrorState(this.failure);
}
