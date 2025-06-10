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
  ObservableList<PostModel> posts = ObservableList<PostModel>();

  @observable
  FetchPostsState state = FetchPostsInitialState();

  CategoryModel? _lastCategory;

  String? _lastSearchText;

  DocumentSnapshot? _lastDocument;

  @action
  Future<void> fetchPosts(
    CategoryModel category, {
    String? searchText,
  }) async {
    if (state is FetchPostsLoadingState) return;

    if (category != _lastCategory || searchText != _lastSearchText) {
      state = FetchPostsLoadingState();
      posts.clear();

      _lastDocument = null;
    }

    final result = await _repository.fetchPosts(
      category,
      searchText: searchText,
      startAfterDocument: _lastDocument,
    );

    result.fold(
      (failure) {
        state = FetchPostsErrorState(failure.message);
      },
      (paginatedPosts) {
        final newPosts = posts;
        newPosts.addAll(paginatedPosts.posts);
        posts = newPosts.asObservable();

        _lastCategory = category;
        _lastSearchText = searchText;
        _lastDocument = paginatedPosts.lastDocument;

        state = FetchPostsSuccessState();
      },
    );
  }

  PostModel? getPostById(String id) {
    return posts.firstWhereOrNull((element) => element.id == id);
  }
}
