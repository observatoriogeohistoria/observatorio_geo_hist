import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/features/posts/infra/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/posts/infra/repositories/fetch_posts_repository.dart';

part 'fetch_posts_store.g.dart';

class FetchPostsStore = FetchPostsStoreBase with _$FetchPostsStore;

abstract class FetchPostsStoreBase with Store {
  final FetchPostsRepository _repository;

  FetchPostsStoreBase(this._repository);

  @observable
  ObservableList<PostModel> posts = ObservableList<PostModel>();

  @action
  Future<void> fetchPosts(CategoryModel category) async {
    final result = await _repository.fetchPosts(category);
    result.fold(
      (failure) {},
      (posts) => this.posts = ObservableList.of(posts),
    );
  }
}
