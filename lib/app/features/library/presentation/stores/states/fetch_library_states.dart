import 'package:equatable/equatable.dart';

sealed class FetchLibraryState extends Equatable {
  @override
  List<Object> get props => [];
}

final class FetchLibraryInitialState extends FetchLibraryState {}

final class FetchLibraryLoadingState extends FetchLibraryState {
  final bool isRefreshing;
  FetchLibraryLoadingState({this.isRefreshing = false});
}

final class FetchLibrarySuccessState extends FetchLibraryState {}

final class FetchLibraryErrorState extends FetchLibraryState {
  final String message;
  FetchLibraryErrorState(this.message);
}
