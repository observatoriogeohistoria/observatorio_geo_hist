import 'package:equatable/equatable.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';

sealed class ManageMediaState extends Equatable {
  @override
  List<Object> get props => [];
}

final class ManageMediaInitialState extends ManageMediaState {}

final class ManageMediaLoadingState extends ManageMediaState {
  final bool isRefreshing;
  ManageMediaLoadingState({this.isRefreshing = false});
}

final class ManageMediaSuccessState extends ManageMediaState {
  final String message;
  ManageMediaSuccessState({this.message = ''});
}

final class ManageMediaErrorState extends ManageMediaState {
  final Failure failure;
  ManageMediaErrorState(this.failure);
}
