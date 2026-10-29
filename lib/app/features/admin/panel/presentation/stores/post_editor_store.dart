import 'package:fpdart/fpdart.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/models/states/crud_states.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/repositories/posts_repository.dart';

part 'post_editor_store.g.dart';

class PostEditorStore = PostEditorStoreBase with _$PostEditorStore;

abstract class PostEditorStoreBase with Store {
  final PostsRepository _postsRepository;

  PostEditorStoreBase(this._postsRepository);

  @observable
  CrudState loadState = CrudInitialState();

  @observable
  bool isSaving = false;

  @observable
  PostModel? post;

  @action
  Future<void> load(String categoryKey, String id) async {
    loadState = CrudLoadingState();

    final result = await _postsRepository.getPost(categoryKey, id);

    result.fold(
      (failure) => loadState = CrudErrorState(failure),
      (data) {
        post = data;
        loadState = CrudSuccessState();
      },
    );
  }

  /// The caller picks the notice, because it depends on the button used.
  @action
  Future<Either<Failure, PostModel>> save(PostModel post, CategoryModel? pastCategory) async {
    isSaving = true;

    final result = await _postsRepository.createOrUpdatePost(post, pastCategory);

    result.fold((_) {}, (data) => this.post = data.copyWith(category: post.category));
    isSaving = false;
    return result;
  }
}
