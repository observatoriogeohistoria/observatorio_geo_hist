// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_detail_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PostDetailStore on PostDetailStoreBase, Store {
  late final _$stateAtom =
      Atom(name: 'PostDetailStoreBase.state', context: context);

  @override
  PostDetailState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(PostDetailState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$relatedAtom =
      Atom(name: 'PostDetailStoreBase.related', context: context);

  @override
  ObservableList<PostModel> get related {
    _$relatedAtom.reportRead();
    return super.related;
  }

  @override
  set related(ObservableList<PostModel> value) {
    _$relatedAtom.reportWrite(value, super.related, () {
      super.related = value;
    });
  }

  late final _$fetchAsyncAction =
      AsyncAction('PostDetailStoreBase.fetch', context: context);

  @override
  Future<void> fetch(CategoryModel category, String postId) {
    return _$fetchAsyncAction.run(() => super.fetch(category, postId));
  }

  late final _$fetchRelatedAsyncAction =
      AsyncAction('PostDetailStoreBase.fetchRelated', context: context);

  @override
  Future<void> fetchRelated(CategoryModel category, PostModel post) {
    return _$fetchRelatedAsyncAction
        .run(() => super.fetchRelated(category, post));
  }

  late final _$PostDetailStoreBaseActionController =
      ActionController(name: 'PostDetailStoreBase', context: context);

  @override
  void setLoading() {
    final _$actionInfo = _$PostDetailStoreBaseActionController.startAction(
        name: 'PostDetailStoreBase.setLoading');
    try {
      return super.setLoading();
    } finally {
      _$PostDetailStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNotFound() {
    final _$actionInfo = _$PostDetailStoreBaseActionController.startAction(
        name: 'PostDetailStoreBase.setNotFound');
    try {
      return super.setNotFound();
    } finally {
      _$PostDetailStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError() {
    final _$actionInfo = _$PostDetailStoreBaseActionController.startAction(
        name: 'PostDetailStoreBase.setError');
    try {
      return super.setError();
    } finally {
      _$PostDetailStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
state: ${state},
related: ${related}
    ''';
  }
}
