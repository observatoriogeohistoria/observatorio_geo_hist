import 'package:equatable/equatable.dart';

sealed class FetchHighlightsState extends Equatable {
  @override
  List<Object> get props => [];
}

final class FetchHighlightsInitialState extends FetchHighlightsState {}

final class FetchHighlightsLoadingState extends FetchHighlightsState {}

final class FetchHighlightsSuccessState extends FetchHighlightsState {}

final class FetchHighlightsErrorState extends FetchHighlightsState {
  final String message;
  FetchHighlightsErrorState(this.message);
}
