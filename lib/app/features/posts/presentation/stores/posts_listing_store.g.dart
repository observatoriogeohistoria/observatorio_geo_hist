// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_listing_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PostsListingStore on PostsListingStoreBase, Store {
  Computed<List<PostType>>? _$typesWithPostsComputed;

  @override
  List<PostType> get typesWithPosts => (_$typesWithPostsComputed ??=
          Computed<List<PostType>>(() => super.typesWithPosts,
              name: 'PostsListingStoreBase.typesWithPosts'))
      .value;
  Computed<List<PostsTypeBlock>>? _$visibleBlocksComputed;

  @override
  List<PostsTypeBlock> get visibleBlocks => (_$visibleBlocksComputed ??=
          Computed<List<PostsTypeBlock>>(() => super.visibleBlocks,
              name: 'PostsListingStoreBase.visibleBlocks'))
      .value;
  Computed<int?>? _$totalCountComputed;

  @override
  int? get totalCount =>
      (_$totalCountComputed ??= Computed<int?>(() => super.totalCount,
              name: 'PostsListingStoreBase.totalCount'))
          .value;

  late final _$statusAtom =
      Atom(name: 'PostsListingStoreBase.status', context: context);

  @override
  PostsListingStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(PostsListingStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  late final _$blocksAtom =
      Atom(name: 'PostsListingStoreBase.blocks', context: context);

  @override
  List<PostsTypeBlock> get blocks {
    _$blocksAtom.reportRead();
    return super.blocks;
  }

  @override
  set blocks(List<PostsTypeBlock> value) {
    _$blocksAtom.reportWrite(value, super.blocks, () {
      super.blocks = value;
    });
  }

  late final _$countsAtom =
      Atom(name: 'PostsListingStoreBase.counts', context: context);

  @override
  Map<PostType, int>? get counts {
    _$countsAtom.reportRead();
    return super.counts;
  }

  @override
  set counts(Map<PostType, int>? value) {
    _$countsAtom.reportWrite(value, super.counts, () {
      super.counts = value;
    });
  }

  late final _$selectedTypeAtom =
      Atom(name: 'PostsListingStoreBase.selectedType', context: context);

  @override
  PostType? get selectedType {
    _$selectedTypeAtom.reportRead();
    return super.selectedType;
  }

  @override
  set selectedType(PostType? value) {
    _$selectedTypeAtom.reportWrite(value, super.selectedType, () {
      super.selectedType = value;
    });
  }

  late final _$searchTextAtom =
      Atom(name: 'PostsListingStoreBase.searchText', context: context);

  @override
  String get searchText {
    _$searchTextAtom.reportRead();
    return super.searchText;
  }

  @override
  set searchText(String value) {
    _$searchTextAtom.reportWrite(value, super.searchText, () {
      super.searchText = value;
    });
  }

  late final _$_fetchAsyncAction =
      AsyncAction('PostsListingStoreBase._fetch', context: context);

  @override
  Future<void> _fetch() {
    return _$_fetchAsyncAction.run(() => super._fetch());
  }

  late final _$loadMoreAsyncAction =
      AsyncAction('PostsListingStoreBase.loadMore', context: context);

  @override
  Future<void> loadMore(PostType type) {
    return _$loadMoreAsyncAction.run(() => super.loadMore(type));
  }

  late final _$PostsListingStoreBaseActionController =
      ActionController(name: 'PostsListingStoreBase', context: context);

  @override
  Future<void> load(PostsListingScope scope) {
    final _$actionInfo = _$PostsListingStoreBaseActionController.startAction(
        name: 'PostsListingStoreBase.load');
    try {
      return super.load(scope);
    } finally {
      _$PostsListingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> search(String text) {
    final _$actionInfo = _$PostsListingStoreBaseActionController.startAction(
        name: 'PostsListingStoreBase.search');
    try {
      return super.search(text);
    } finally {
      _$PostsListingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> clearSearch() {
    final _$actionInfo = _$PostsListingStoreBaseActionController.startAction(
        name: 'PostsListingStoreBase.clearSearch');
    try {
      return super.clearSearch();
    } finally {
      _$PostsListingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectType(PostType? type) {
    final _$actionInfo = _$PostsListingStoreBaseActionController.startAction(
        name: 'PostsListingStoreBase.selectType');
    try {
      return super.selectType(type);
    } finally {
      _$PostsListingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> retry() {
    final _$actionInfo = _$PostsListingStoreBaseActionController.startAction(
        name: 'PostsListingStoreBase.retry');
    try {
      return super.retry();
    } finally {
      _$PostsListingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _setCounts(Map<PostType, int>? value) {
    final _$actionInfo = _$PostsListingStoreBaseActionController.startAction(
        name: 'PostsListingStoreBase._setCounts');
    try {
      return super._setCounts(value);
    } finally {
      _$PostsListingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _replaceBlock(PostsTypeBlock updated) {
    final _$actionInfo = _$PostsListingStoreBaseActionController.startAction(
        name: 'PostsListingStoreBase._replaceBlock');
    try {
      return super._replaceBlock(updated);
    } finally {
      _$PostsListingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
status: ${status},
blocks: ${blocks},
counts: ${counts},
selectedType: ${selectedType},
searchText: ${searchText},
typesWithPosts: ${typesWithPosts},
visibleBlocks: ${visibleBlocks},
totalCount: ${totalCount}
    ''';
  }
}
