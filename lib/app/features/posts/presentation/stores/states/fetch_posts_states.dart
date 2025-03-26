import 'package:equatable/equatable.dart';

sealed class FetchPostsState extends Equatable {
  @override
  List<Object> get props => [];
}

final class FetchPostsInitialState extends FetchPostsState {}

final class FetchPostsLoadingState extends FetchPostsState {}

final class FetchPostsSuccessState extends FetchPostsState {}

final class FetchPostsErrorState extends FetchPostsState {
  final String message;
  FetchPostsErrorState(this.message);
}
