import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/media_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/repositories/media_repository.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/crud_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/states/crud_states.dart';

part 'media_store.g.dart';

class MediaStore = MediaStoreBase with _$MediaStore;

abstract class MediaStoreBase extends CrudStore<MediaModel> with Store {
  final MediaRepository _mediaRepository;

  MediaStoreBase(this._mediaRepository);

  @override
  @observable
  ObservableList<MediaModel> items = ObservableList<MediaModel>();

  @override
  @observable
  CrudState state = CrudInitialState();

  @override
  @action
  Future<void> getItems() async {
    if (state is CrudLoadingState) return;
    if (items.isNotEmpty) return;

    state = CrudLoadingState();

    final result = await _mediaRepository.getMedias();

    result.fold(
      (failure) => state = CrudErrorState(failure),
      (medias) {
        items = medias.asObservable();
        state = CrudSuccessState();
      },
    );
  }

  @override
  @action
  Future<void> createOrUpdateItem(MediaModel item, {dynamic extra}) async {
    state = CrudLoadingState(isRefreshing: true);

    final result = await _mediaRepository.createMedia(item);

    result.fold(
      (failure) => state = CrudErrorState(failure),
      (media) {
        items.add(media);
        state = CrudSuccessState(message: 'Mídia criada com sucesso');
      },
    );
  }

  @override
  @action
  Future<void> deleteItem(MediaModel item) async {
    state = CrudLoadingState(isRefreshing: true);

    final result = await _mediaRepository.deleteMedia(item);

    result.fold(
      (failure) => state = CrudErrorState(failure),
      (_) {
        items.remove(item);
        state = CrudSuccessState(message: 'Mídia deletada com sucesso');
      },
    );
  }
}
