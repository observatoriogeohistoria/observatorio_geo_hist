import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/repositories/posts/posts_repository.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/states/posts_states.dart';

part 'posts_store.g.dart';

class PostsStore = PostsStoreBase with _$PostsStore;

abstract class PostsStoreBase with Store {
  final PostsRepository _postsRepository;

  PostsStoreBase(this._postsRepository);

  @observable
  ObservableList<PostModel> posts = ObservableList<PostModel>();

  @observable
  ManagePostsState state = ManagePostsInitialState();

  @action
  Future<void> getPosts({
    bool emitLoading = true,
    bool force = false,
  }) async {
    if (!force && posts.isNotEmpty) return;
    if (emitLoading) state = ManagePostsLoadingState();

    final result = await _postsRepository.getPosts();

    result.fold(
      (failure) => state = ManagePostsErrorState(failure),
      (posts) {
        this.posts = posts.asObservable();
        state = ManagePostsSuccessState();
      },
    );
  }

  @action
  Future<void> createOrUpdatePost(PostModel post) async {
    state = ManagePostsLoadingState();

    final result = await _postsRepository.createOrUpdatePost(post);

    result.fold(
      (failure) => state = ManagePostsErrorState(failure),
      (_) {
        getPosts(emitLoading: false, force: true);
        state = ManagePostsSuccessState();
      },
    );
  }

  @action
  Future<void> deletePost(PostModel post) async {
    state = ManagePostsLoadingState();

    final result = await _postsRepository.deletePost(post);

    result.fold(
      (failure) => state = ManagePostsErrorState(failure),
      (_) {
        getPosts(emitLoading: false, force: true);
        state = ManagePostsSuccessState();
      },
    );
  }
}
