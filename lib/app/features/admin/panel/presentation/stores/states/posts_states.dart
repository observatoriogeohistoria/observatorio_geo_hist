import 'package:equatable/equatable.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';

sealed class ManagePostsState extends Equatable {
  @override
  List<Object> get props => [];
}

final class ManagePostsInitialState extends ManagePostsState {}

final class ManagePostsLoadingState extends ManagePostsState {
  final bool isRefreshing;
  ManagePostsLoadingState({this.isRefreshing = false});
}

final class ManagePostsSuccessState extends ManagePostsState {
  final String message;
  ManagePostsSuccessState({this.message = ''});
}

final class ManagePostsErrorState extends ManagePostsState {
  final Failure failure;
  ManagePostsErrorState(this.failure);
}
