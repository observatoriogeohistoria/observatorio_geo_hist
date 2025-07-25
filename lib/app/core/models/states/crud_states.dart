import 'package:equatable/equatable.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';

sealed class CrudState extends Equatable {
  @override
  List<Object> get props => [];
}

final class CrudInitialState extends CrudState {}

final class CrudLoadingState extends CrudState {
  final bool isRefreshing;
  CrudLoadingState({this.isRefreshing = false});
}

final class CrudSuccessState extends CrudState {
  final String message;
  CrudSuccessState({this.message = ''});
}

final class CrudErrorState extends CrudState {
  final Failure failure;
  CrudErrorState(this.failure);
}
