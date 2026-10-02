import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/posts/infra/repositories/fetch_posts_repository.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/stores/states/posts_listing_states.dart';

part 'posts_listing_store.g.dart';

/// Um por página: a listagem da categoria e a de todas as publicações não dividem estado.
class PostsListingStore = PostsListingStoreBase with _$PostsListingStore;

abstract class PostsListingStoreBase with Store {
  PostsListingStoreBase(this._repository);

  final FetchPostsRepository _repository;

  /// Fecha linhas inteiras em 1, 2 e 3 colunas.
  static const pageSize = 12;

  PostsListingScope? _scope;

  // Descarta respostas de uma busca ou escopo anterior que chegam atrasadas.
  int _request = 0;

  @observable
  PostsListingStatus status = PostsListingStatus.initial;

  @observable
  List<PostsTypeBlock> blocks = const [];

  /// Nulo enquanto carrega ou se a contagem falhou: aí os números somem.
  @observable
  Map<PostType, int>? counts;

  @observable
  PostType? selectedType;

  @observable
  String searchText = '';

  @computed
  List<PostType> get typesWithPosts => [for (final block in blocks) block.type];

  @computed
  List<PostsTypeBlock> get visibleBlocks =>
      selectedType == null ? blocks : blocks.where((block) => block.type == selectedType).toList();

  @computed
  int? get totalCount {
    final counts = this.counts;
    if (counts == null) return null;
    if (selectedType != null) return counts[selectedType];
    return typesWithPosts.fold<int>(
      0,
      (sum, type) => sum + (counts[type] ?? 0),
    );
  }

  @action
  Future<void> load(PostsListingScope scope) {
    _scope = scope;
    searchText = '';
    selectedType = null;
    return _fetch();
  }

  @action
  Future<void> search(String text) {
    final normalized = text.trim();
    if (normalized == searchText && status != PostsListingStatus.error) return Future.value();
    searchText = normalized;
    return _fetch();
  }

  @action
  Future<void> clearSearch() {
    selectedType = null;
    return search('');
  }

  @action
  void selectType(PostType? type) => selectedType = type;

  @action
  Future<void> retry() => _fetch();

  @action
  Future<void> _fetch() async {
    final scope = _scope;
    if (scope == null) return;

    final request = ++_request;
    status = PostsListingStatus.loading;
    blocks = const [];
    counts = null;

    final search = searchText;
    _fetchCounts(scope, search, request);

    final results = await Future.wait([
      for (final type in scope.types)
        _repository.fetchPosts(
          scope.category,
          postType: type,
          searchText: search,
          limit: pageSize,
        ),
    ]);
    if (request != _request) return;

    if (results.any((result) => result.isLeft())) {
      status = PostsListingStatus.error;
      return;
    }

    final loaded = <PostsTypeBlock>[];
    for (final (index, result) in results.indexed) {
      final page = result.getRight().toNullable()!;
      if (page.posts.isEmpty) continue;
      loaded.add(
        PostsTypeBlock(
          type: scope.types[index],
          posts: page.posts,
          cursor: page.lastDocument,
          hasMore: page.hasMore,
        ),
      );
    }

    blocks = loaded;
    if (!typesWithPosts.contains(selectedType)) selectedType = null;
    status = loaded.isEmpty ? PostsListingStatus.empty : PostsListingStatus.success;
  }

  Future<void> _fetchCounts(
    PostsListingScope scope,
    String search,
    int request,
  ) async {
    final results = await Future.wait([
      for (final type in scope.types)
        _repository.countPosts(
          category: scope.category,
          postType: type,
          searchText: search,
        ),
    ]);
    if (request != _request) return;

    _setCounts(
      results.any((result) => result.isLeft())
          ? null
          : {
              for (final (index, result) in results.indexed)
                scope.types[index]: result.getRight().toNullable()!,
            },
    );
  }

  @action
  void _setCounts(Map<PostType, int>? value) => counts = value;

  @action
  Future<void> loadMore(PostType type) async {
    final scope = _scope;
    final block = _blockOf(type);
    if (scope == null || block == null || block.isLoadingMore || !block.hasMore) return;

    final request = _request;
    _replaceBlock(block.copyWith(isLoadingMore: true, loadMoreFailed: false));

    final result = await _repository.fetchPosts(
      scope.category,
      postType: type,
      searchText: searchText,
      startAfterDocument: block.cursor,
      limit: pageSize,
    );
    if (request != _request) return;

    final current = _blockOf(type)!;
    result.fold(
      (_) => _replaceBlock(
        current.copyWith(isLoadingMore: false, loadMoreFailed: true),
      ),
      (page) => _replaceBlock(
        current.copyWith(
          posts: [...current.posts, ...page.posts],
          cursor: page.lastDocument,
          hasMore: page.hasMore,
          isLoadingMore: false,
        ),
      ),
    );
  }

  PostsTypeBlock? _blockOf(PostType type) {
    for (final block in blocks) {
      if (block.type == type) return block;
    }
    return null;
  }

  @action
  void _replaceBlock(PostsTypeBlock updated) {
    blocks = [
      for (final block in blocks) block.type == updated.type ? updated : block,
    ];
  }
}
