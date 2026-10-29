import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

enum PostsListingStatus { initial, loading, success, empty, error }

/// Where the posts come from. Without [category], applies to every category.
class PostsListingScope extends Equatable {
  const PostsListingScope({this.category, required this.types, required this.pageSize});

  // 12 and 6 fill whole rows in 1, 2 and 3 columns. The all-posts page shows every type
  // at once, so each block starts smaller.
  factory PostsListingScope.ofCategory(CategoryModel category) =>
      PostsListingScope(category: category, types: category.postsTypes, pageSize: 12);

  /// Without a category there's no stored order: types follow the alphabetical order of their names.
  factory PostsListingScope.all() => PostsListingScope(
        types: [...PostType.values]
          ..sort((a, b) => a.portuguesePlural.compareTo(b.portuguesePlural)),
        pageSize: 6,
      );

  final CategoryModel? category;
  final List<PostType> types;
  final int pageSize;

  @override
  List<Object?> get props => [category?.key, category?.areas, types, pageSize];
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
