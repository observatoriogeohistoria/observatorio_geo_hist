import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/repositories/posts_repository.dart';
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
  Future<void> getPosts() async {
    if (state is ManagePostsLoadingState) return;
    if (posts.isNotEmpty) return;

    state = ManagePostsLoadingState();

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
    state = ManagePostsLoadingState(isRefreshing: true);

    final result = await _postsRepository.createOrUpdatePost(post);

    result.fold(
      (failure) => state = ManagePostsErrorState(failure),
      (data) {
        final index = posts.indexWhere((p) => p.id == data.id);

        bool isUpdate = index >= 0;
        index >= 0 ? posts.replaceRange(index, index + 1, [data]) : posts.add(data);

        state = ManagePostsSuccessState(
          message: isUpdate ? 'Post atualizado com sucesso' : 'Post criado com sucesso',
        );
      },
    );
  }

  @action
  Future<void> deletePost(PostModel post) async {
    state = ManagePostsLoadingState(isRefreshing: true);

    final result = await _postsRepository.deletePost(post);

    result.fold(
      (failure) => state = ManagePostsErrorState(failure),
      (_) {
        posts.removeWhere((p) => p.id == post.id);
        state = ManagePostsSuccessState(
          message: 'Post deletado com sucesso',
        );
      },
    );
  }
}
