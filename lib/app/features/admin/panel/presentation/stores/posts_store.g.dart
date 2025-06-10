// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PostsStore on PostsStoreBase, Store {
  late final _$postsAtom = Atom(name: 'PostsStoreBase.posts', context: context);

  @override
  ObservableMap<PostType, List<PostModel>> get posts {
    _$postsAtom.reportRead();
    return super.posts;
  }

  @override
  set posts(ObservableMap<PostType, List<PostModel>> value) {
    _$postsAtom.reportWrite(value, super.posts, () {
      super.posts = value;
    });
  }

  late final _$stateAtom = Atom(name: 'PostsStoreBase.state', context: context);

  @override
  CrudState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(CrudState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$getPostsAsyncAction =
      AsyncAction('PostsStoreBase.getPosts', context: context);

  @override
  Future<void> getPosts(PostType type,
      {String? searchText,
      PostsAreas? searchArea,
      CategoryModel? searchCategory}) {
    return _$getPostsAsyncAction.run(() => super.getPosts(type,
        searchText: searchText,
        searchArea: searchArea,
        searchCategory: searchCategory));
  }

  late final _$createOrUpdatePostAsyncAction =
      AsyncAction('PostsStoreBase.createOrUpdatePost', context: context);

  @override
  Future<void> createOrUpdatePost(PostModel post, CategoryModel? pastCategory) {
    return _$createOrUpdatePostAsyncAction
        .run(() => super.createOrUpdatePost(post, pastCategory));
  }

  late final _$deletePostAsyncAction =
      AsyncAction('PostsStoreBase.deletePost', context: context);

  @override
  Future<void> deletePost(PostModel post) {
    return _$deletePostAsyncAction.run(() => super.deletePost(post));
  }

  @override
  String toString() {
    return '''
posts: ${posts},
state: ${state}
    ''';
  }
}
