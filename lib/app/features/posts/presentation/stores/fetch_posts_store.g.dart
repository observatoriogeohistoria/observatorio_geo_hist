// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_posts_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FetchPostsStore on FetchPostsStoreBase, Store {
  late final _$postsAtom =
      Atom(name: 'FetchPostsStoreBase.posts', context: context);

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

  late final _$stateAtom =
      Atom(name: 'FetchPostsStoreBase.state', context: context);

  @override
  FetchPostsState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(FetchPostsState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$fetchPostsAsyncAction =
      AsyncAction('FetchPostsStoreBase.fetchPosts', context: context);

  @override
  Future<void> fetchPosts(CategoryModel category, PostType postType,
      {String? searchText}) {
    return _$fetchPostsAsyncAction.run(
        () => super.fetchPosts(category, postType, searchText: searchText));
  }

  @override
  String toString() {
    return '''
posts: ${posts},
state: ${state}
    ''';
  }
}
