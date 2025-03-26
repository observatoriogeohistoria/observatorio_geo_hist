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

  @action
  Future<void> fetchPosts(CategoryModel category) async {
    state = FetchPostsLoadingState();
    posts.clear();

    final result = await _repository.fetchPosts(category);

    result.fold(
      (failure) {
        state = FetchPostsErrorState(failure.message);
      },
      (posts) {
        this.posts = posts.asObservable();
        state = FetchPostsSuccessState();
      },
    );
  }

  PostModel? getPostById(String id) {
    return posts.firstWhereOrNull((element) => element.id == id);
  }
}
