import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
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
  ObservableMap<PostType, List<PostModel>> postsByType = ObservableMap<PostType, List<PostModel>>();

  @observable
  ObservableList<PostModel> posts = ObservableList<PostModel>();

  @observable
  Map<PostType, bool> hasMore = {for (PostType type in PostType.values) type: true};

  @observable
  FetchPostsState state = FetchPostsInitialState();

  CategoryModel? _lastCategory;

  String? _lastSearchText;

  Map<PostType, DocumentSnapshot?> _lastDocument = {
    for (PostType type in PostType.values) type: null
  };

  @action
  Future<void> fetchPostsByType(
    CategoryModel category,
    PostType postType, {
    String? searchText,
  }) async {
    if (category != _lastCategory || searchText != _lastSearchText) {
      postsByType.clear();

      hasMore = {for (PostType type in PostType.values) type: true};
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
  Future<void> fetchPosts(CategoryModel category) async {
    state = FetchPostsLoadingState(isRefreshing: state is! FetchPostsInitialState);

    final result = await _repository.fetchPosts(category);

    result.fold(
      (failure) {
        state = FetchPostsErrorState(failure.message);
      },
      (paginatedPosts) {
        posts = paginatedPosts.posts.asObservable();
        state = FetchPostsSuccessState();
      },
    );
  }

  PostModel? getPostById(String id) {
    final post = posts.firstWhereOrNull((element) => element.id == id);
    return post;
  }
}
