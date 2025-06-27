// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_posts_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FetchPostsStore on FetchPostsStoreBase, Store {
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

  late final _$postsByTypeAtom =
      Atom(name: 'FetchPostsStoreBase.postsByType', context: context);

  @override
  ObservableMap<PostType, List<PostModel>> get postsByType {
    _$postsByTypeAtom.reportRead();
    return super.postsByType;
  }

  @override
  set postsByType(ObservableMap<PostType, List<PostModel>> value) {
    _$postsByTypeAtom.reportWrite(value, super.postsByType, () {
      super.postsByType = value;
    });
  }

  late final _$selectedPostAtom =
      Atom(name: 'FetchPostsStoreBase.selectedPost', context: context);

  @override
  Observable<PostModel>? get selectedPost {
    _$selectedPostAtom.reportRead();
    return super.selectedPost;
  }

  @override
  set selectedPost(Observable<PostModel>? value) {
    _$selectedPostAtom.reportWrite(value, super.selectedPost, () {
      super.selectedPost = value;
    });
  }

  late final _$hasMoreAtom =
      Atom(name: 'FetchPostsStoreBase.hasMore', context: context);

  @override
  Map<PostType, bool> get hasMore {
    _$hasMoreAtom.reportRead();
    return super.hasMore;
  }

  @override
  set hasMore(Map<PostType, bool> value) {
    _$hasMoreAtom.reportWrite(value, super.hasMore, () {
      super.hasMore = value;
    });
  }

  late final _$fetchPostsByTypeAsyncAction =
      AsyncAction('FetchPostsStoreBase.fetchPostsByType', context: context);

  @override
  Future<void> fetchPostsByType(CategoryModel category, PostType postType,
      {String? searchText}) {
    return _$fetchPostsByTypeAsyncAction.run(() =>
        super.fetchPostsByType(category, postType, searchText: searchText));
  }

  late final _$fetchPostByIdAsyncAction =
      AsyncAction('FetchPostsStoreBase.fetchPostById', context: context);

  @override
  Future<void> fetchPostById(String postId) {
    return _$fetchPostByIdAsyncAction.run(() => super.fetchPostById(postId));
  }

  late final _$FetchPostsStoreBaseActionController =
      ActionController(name: 'FetchPostsStoreBase', context: context);

  @override
  void reset() {
    final _$actionInfo = _$FetchPostsStoreBaseActionController.startAction(
        name: 'FetchPostsStoreBase.reset');
    try {
      return super.reset();
    } finally {
      _$FetchPostsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
state: ${state},
postsByType: ${postsByType},
selectedPost: ${selectedPost},
hasMore: ${hasMore}
    ''';
  }
}
