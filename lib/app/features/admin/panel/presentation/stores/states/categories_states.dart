import 'package:equatable/equatable.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';

sealed class ManageCategoriesState extends Equatable {
  @override
  List<Object> get props => [];
}

final class ManageCategoriesInitialState extends ManageCategoriesState {}

final class ManageCategoriesLoadingState extends ManageCategoriesState {}

final class ManageCategoriesSuccessState extends ManageCategoriesState {
  final String message;
  ManageCategoriesSuccessState({this.message = ''});
}

final class ManageCategoriesErrorState extends ManageCategoriesState {
  final Failure failure;
  ManageCategoriesErrorState(this.failure);
}
