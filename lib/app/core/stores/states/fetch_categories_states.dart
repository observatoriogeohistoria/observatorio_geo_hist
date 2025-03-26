import 'package:equatable/equatable.dart';

sealed class FetchCategoriesState extends Equatable {
  @override
  List<Object> get props => [];
}

final class FetchCategoriesInitialState extends FetchCategoriesState {}

final class FetchCategoriesLoadingState extends FetchCategoriesState {}

final class FetchCategoriesSuccessState extends FetchCategoriesState {}

final class FetchCategoriesErrorState extends FetchCategoriesState {
  final String message;
  FetchCategoriesErrorState(this.message);
}
