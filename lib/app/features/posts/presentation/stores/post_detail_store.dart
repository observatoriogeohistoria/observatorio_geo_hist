import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/posts/infra/errors/failures.dart';
import 'package:observatorio_geo_hist/app/features/posts/infra/repositories/fetch_posts_repository.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/stores/states/post_detail_states.dart';

part 'post_detail_store.g.dart';

/// Um por página, para não mexer na lista que a página da categoria guarda.
class PostDetailStore = PostDetailStoreBase with _$PostDetailStore;

abstract class PostDetailStoreBase with Store {
  PostDetailStoreBase(this._repository);

  final FetchPostsRepository _repository;

  static const relatedLimit = 3;

  @observable
  PostDetailState state = PostDetailInitialState();

  @observable
  ObservableList<PostModel> related = ObservableList<PostModel>();

  // Descarta respostas de uma busca anterior quando o post muda no meio dela.
  int _request = 0;

  @action
  void setLoading() {
    _request++;
    state = PostDetailLoadingState();
    related.clear();
  }

  @action
  void setNotFound() {
    _request++;
    state = PostDetailNotFoundState();
    related.clear();
  }

  @action
  void setError() {
    _request++;
    state = PostDetailErrorState();
    related.clear();
  }

  @action
  Future<void> fetch(CategoryModel category, String postId) async {
    setLoading();
    final request = _request;

    final result = await _repository.fetchPostById(postId);
    if (request != _request) return;

    result.fold(
      (failure) => state =
          failure is PostNotFoundFailure ? PostDetailNotFoundState() : PostDetailErrorState(),
      (post) {
        if (post.body == null) {
          state = PostDetailNotFoundState();
          return;
        }
        state = PostDetailSuccessState(post.copyWith(category: category));
        if (post.isArticle) fetchRelated(category, post);
      },
    );
  }

  @action
  Future<void> fetchRelated(CategoryModel category, PostModel post) async {
    final request = _request;

    final result = await _repository.fetchPosts(
      category,
      postType: PostType.article,
      limit: relatedLimit + 1,
    );
    if (request != _request) return;

    result.fold(
      (_) => related.clear(),
      (paginated) => related = ObservableList.of(
        paginated.posts.where((item) => item.id != post.id && item.body != null).take(relatedLimit),
      ),
    );
  }
}
