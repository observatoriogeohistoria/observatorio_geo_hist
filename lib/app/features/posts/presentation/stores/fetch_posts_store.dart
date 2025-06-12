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
  ObservableMap<PostType, List<PostModel>> posts = ObservableMap<PostType, List<PostModel>>();

  @observable
  FetchPostsState state = FetchPostsInitialState();

  CategoryModel? _lastCategory;

  String? _lastSearchText;

  Map<PostType, DocumentSnapshot?> _lastDocument = {
    for (PostType type in PostType.values) type: null
  };

  Map<PostType, bool> _hasMore = {for (PostType type in PostType.values) type: true};

  @action
  Future<void> fetchPosts(
    CategoryModel category,
    PostType postType, {
    String? searchText,
  }) async {
    if (category != _lastCategory || searchText != _lastSearchText) {
      posts.clear();

      _hasMore = {for (PostType type in PostType.values) type: true};
      _lastDocument = {for (PostType type in PostType.values) type: null};
    }

    if (_hasMore[postType] == false) return;

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
        final newPosts = posts[postType] ?? [];
        newPosts.addAll(paginatedPosts.posts);

        posts[postType] = newPosts.asObservable();

        _lastCategory = category;
        _lastSearchText = searchText;

        _lastDocument[postType] = paginatedPosts.lastDocument;
        _hasMore[postType] = paginatedPosts.hasMore;

        state = FetchPostsSuccessState();
      },
    );
  }

  PostModel? getPostById(String id) {
    if (posts.isEmpty) return null;

    for (final entries in posts.entries) {
      final post = entries.value.firstWhereOrNull((element) => element.id == id);
      if (post != null) return post;
    }

    return null;
  }
}
