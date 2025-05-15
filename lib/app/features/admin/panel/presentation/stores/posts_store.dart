import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/repositories/posts_repository.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/states/crud_states.dart';

part 'posts_store.g.dart';

class PostsStore = PostsStoreBase with _$PostsStore;

abstract class PostsStoreBase with Store {
  final PostsRepository _postsRepository;

  PostsStoreBase(this._postsRepository);

  @observable
  ObservableMap<PostType, List<PostModel>> posts = ObservableMap<PostType, List<PostModel>>();

  @observable
  CrudState state = CrudInitialState();

  @action
  Future<void> getPosts(PostType type) async {
    if (state is CrudLoadingState) return;
    if (posts.containsKey(type)) return;

    state = CrudLoadingState();

    final result = await _postsRepository.getPosts(type);

    result.fold(
      (failure) => state = CrudErrorState(failure),
      (posts) {
        this.posts[type] = posts.asObservable();
        state = CrudSuccessState();
      },
    );
  }

  @action
  Future<void> createOrUpdatePost(PostModel post) async {
    state = CrudLoadingState(isRefreshing: true);

    final result = await _postsRepository.createOrUpdatePost(post);

    result.fold(
      (failure) => state = CrudErrorState(failure),
      (data) {
        List<PostModel> postsByType = posts[data.type] ?? [];
        final index = postsByType.indexWhere((p) => p.id == data.id);

        bool isUpdate = index >= 0;
        index >= 0 ? postsByType.replaceRange(index, index + 1, [data]) : postsByType.add(data);

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

        state = CrudSuccessState(
          message: 'Post deletado com sucesso',
        );
      },
    );
  }
}
