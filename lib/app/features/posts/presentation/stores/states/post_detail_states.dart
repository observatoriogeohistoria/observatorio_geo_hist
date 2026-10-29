import 'package:equatable/equatable.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

sealed class PostDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class PostDetailInitialState extends PostDetailState {}

final class PostDetailLoadingState extends PostDetailState {}

final class PostDetailSuccessState extends PostDetailState {
  PostDetailSuccessState(this.post);

  final PostModel post;

  @override
  List<Object?> get props => [post];
}

final class PostDetailNotFoundState extends PostDetailState {}

final class PostDetailErrorState extends PostDetailState {}
