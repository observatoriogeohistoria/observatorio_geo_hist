import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/repositories/posts_repository.dart';
import 'package:observatorio_geo_hist/app/core/models/states/crud_states.dart';

part 'posts_store.g.dart';

class PostsStore = PostsStoreBase with _$PostsStore;

abstract class PostsStoreBase with Store {
  final PostsRepository _postsRepository;

  PostsStoreBase(this._postsRepository);

  @observable
  ObservableMap<PostType, List<PostModel>> posts = ObservableMap<PostType, List<PostModel>>();

  @observable
  CrudState state = CrudInitialState();

  final Map<PostType, String?> _lastSearchText = {
    for (PostType type in PostType.values) type: null
  };

  final Map<PostType, PostsAreas?> _lastSearchArea = {
    for (PostType type in PostType.values) type: null
  };

  final Map<PostType, CategoryModel?> _lastSearchCategory = {
    for (PostType type in PostType.values) type: null
  };

  final Map<PostType, bool?> _lastIsPublished = {for (PostType type in PostType.values) type: null};

  final Map<PostType, bool?> _lastIsHighlighted = {
    for (PostType type in PostType.values) type: null
  };

  final Map<PostType, DocumentSnapshot?> _lastDocument = {
    for (PostType type in PostType.values) type: null
  };

  final Map<PostType, bool> _hasMore = {for (PostType type in PostType.values) type: true};

  int _request = 0;

  bool hasMore(PostType type) => _hasMore[type] ?? false;

  /// Com filtro novo (ou [reset]) começa da primeira página e ignora a resposta que ainda
  /// estava a caminho; com os mesmos filtros, traz a próxima página.
  @action
  Future<void> getPosts(
    PostType type, {
    String? searchText,
    PostsAreas? searchArea,
    CategoryModel? searchCategory,
    bool? isPublished,
    bool? isHighlighted,
    bool reset = false,
  }) async {
    final normalizedSearchText = searchText?.toLowerCase();
    final filtersChanged = reset ||
        normalizedSearchText != _lastSearchText[type] ||
        searchArea != _lastSearchArea[type] ||
        searchCategory?.key != _lastSearchCategory[type]?.key ||
        isPublished != _lastIsPublished[type] ||
        isHighlighted != _lastIsHighlighted[type];

    if (state is CrudLoadingState && !filtersChanged) return;

    if (filtersChanged) {
      posts[type] = [];
      _hasMore[type] = true;
      _lastDocument[type] = null;
      _lastSearchText[type] = normalizedSearchText;
      _lastSearchArea[type] = searchArea;
      _lastSearchCategory[type] = searchCategory;
      _lastIsPublished[type] = isPublished;
      _lastIsHighlighted[type] = isHighlighted;
    }

    if (_hasMore[type] == false) return;

    final request = ++_request;
    state = CrudLoadingState(isRefreshing: _lastDocument[type] != null);

    final result = await _postsRepository.getPosts(
      type,
      searchText: normalizedSearchText,
      searchArea: searchArea,
      searchCategory: searchCategory,
      isPublished: isPublished,
      isHighlighted: isHighlighted,
      startAfterDocument: _lastDocument[type],
    );

    if (request != _request) return;

    result.fold(
      (failure) => state = CrudErrorState(failure),
      (paginatedPosts) {
        final newPosts = posts[type] ?? [];
        newPosts.addAll(paginatedPosts.posts);

        posts[type] = newPosts.asObservable();

        _lastDocument[type] = paginatedPosts.lastDocument;
        _hasMore[type] = paginatedPosts.hasMore;

        state = CrudSuccessState();
      },
    );
  }

  @action
  Future<void> createOrUpdatePost(
    PostModel post,
    CategoryModel? pastCategory,
  ) async {
    state = CrudLoadingState(isRefreshing: true);

    final result = await _postsRepository.createOrUpdatePost(post, pastCategory);

    result.fold(
      (failure) => state = CrudErrorState(failure),
      (data) {
        List<PostModel> postsByType = posts[data.type] ?? [];
        final index = postsByType.indexWhere((p) => p.id == data.id);

        bool isUpdate = index >= 0;
        index >= 0
            ? postsByType.replaceRange(index, index + 1, [data])
            : postsByType.insert(0, data);

        posts[data.type] = postsByType.asObservable();

        state = CrudSuccessState(
          message: isUpdate ? 'Post atualizado com sucesso' : 'Post criado com sucesso',
        );
      },
    );
  }

  @action
  Future<void> deletePost(PostModel post) async {
    state = CrudLoadingState(isRefreshing: true);

    final result = await _postsRepository.deletePost(post);

    result.fold(
      (failure) => state = CrudErrorState(failure),
      (_) {
        posts[post.type]?.removeWhere((p) => p.id == post.id);

        state = CrudSuccessState(message: 'Post deletado com sucesso');
      },
    );
  }
}
