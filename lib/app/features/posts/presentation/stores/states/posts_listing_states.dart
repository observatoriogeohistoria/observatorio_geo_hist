import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

enum PostsListingStatus { initial, loading, success, empty, error }

/// De onde vêm as publicações. Sem [category], vale para todas as categorias.
class PostsListingScope extends Equatable {
  const PostsListingScope({this.category, required this.types});

  factory PostsListingScope.ofCategory(CategoryModel category) =>
      PostsListingScope(category: category, types: category.postsTypes);

  final CategoryModel? category;
  final List<PostType> types;

  @override
  List<Object?> get props => [category?.key, category?.areas, types];
}

class PostsTypeBlock {
  const PostsTypeBlock({
    required this.type,
    required this.posts,
    required this.cursor,
    required this.hasMore,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
  });

  final PostType type;
  final List<PostModel> posts;
  final DocumentSnapshot? cursor;
  final bool hasMore;
  final bool isLoadingMore;
  final bool loadMoreFailed;

  PostsTypeBlock copyWith({
    List<PostModel>? posts,
    DocumentSnapshot? cursor,
    bool? hasMore,
    bool? isLoadingMore,
    bool? loadMoreFailed,
  }) {
    return PostsTypeBlock(
      type: type,
      posts: posts ?? this.posts,
      cursor: cursor ?? this.cursor,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
    );
  }
}
