import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/posts/infra/repositories/fetch_posts_repository.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/stores/states/fetch_posts_states.dart';

part 'fetch_posts_store.g.dart';

class FetchPostsStore = FetchPostsStoreBase with _$FetchPostsStore;

abstract class FetchPostsStoreBase with Store {
  final FetchPostsRepository _repository;

  FetchPostsStoreBase(this._repository);

  @observable
  FetchPostsState state = FetchPostsInitialState();

  @observable
  ObservableMap<PostType, List<PostModel>> postsByType = ObservableMap<PostType, List<PostModel>>();

  @observable
  Observable<PostModel>? selectedPost;

  @observable
  ObservableMap<PostType, bool> hasMore = ObservableMap<PostType, bool>();

  Map<PostType, DocumentSnapshot?> _lastDocument = {
    for (PostType type in PostType.values) type: null
  };

  CategoryModel? _lastCategory;

  String? _lastSearchText;

  @action
  void reset() {
    state = FetchPostsInitialState();

    postsByType.clear();
    selectedPost = null;
    hasMore = {for (PostType type in PostType.values) type: true}.asObservable();

    _lastDocument = {for (PostType type in PostType.values) type: null};
    _lastCategory = null;
    _lastSearchText = null;
  }

  @action
  Future<void> fetchPostsByType(
    CategoryModel category,
    PostType postType, {
    String? searchText,
  }) async {
    if (category != _lastCategory || searchText != _lastSearchText) {
      postsByType.clear();
      hasMore = {for (PostType type in PostType.values) type: true}.asObservable();

      _lastDocument = {for (PostType type in PostType.values) type: null};
    }

    if (hasMore[postType] == false) return;

    state = FetchPostsLoadingState(isRefreshing: state is! FetchPostsInitialState);

    final result = await _repository.fetchPosts(
      category,
      postType: postType,
      searchText: searchText,
      startAfterDocument: _lastDocument[postType],
    );

    result.fold(
      (failure) {
        state = FetchPostsErrorState(failure.message);
      },
      (paginatedPosts) {
        final newPosts = postsByType[postType] ?? [];
        newPosts.addAll(paginatedPosts.posts);

        postsByType[postType] = newPosts.asObservable();
        hasMore[postType] = paginatedPosts.hasMore;

        _lastCategory = category;
        _lastSearchText = searchText;
        _lastDocument[postType] = paginatedPosts.lastDocument;

        state = FetchPostsSuccessState();
      },
    );
  }

  @action
  Future<void> fetchPostById(String postId) async {
    state = FetchPostsLoadingState(isRefreshing: state is! FetchPostsInitialState);

    final result = await _repository.fetchPostById(postId);

    result.fold(
      (failure) {
        state = FetchPostsErrorState(failure.message);
      },
      (post) {
        selectedPost = Observable<PostModel>(post);
        state = FetchPostsSuccessState();
      },
    );
  }
}
