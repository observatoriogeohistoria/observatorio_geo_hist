import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/media_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/repositories/media_repository.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/states/media_states.dart';

part 'media_store.g.dart';

class MediaStore = MediaStoreBase with _$MediaStore;

abstract class MediaStoreBase with Store {
  final MediaRepository _mediaRepository;

  MediaStoreBase(this._mediaRepository);

  @observable
  ObservableList<MediaModel> medias = ObservableList<MediaModel>();

  @observable
  ManageMediaState state = ManageMediaInitialState();

  @action
  Future<void> getMedias() async {
    if (state is ManageMediaLoadingState) return;
    if (medias.isNotEmpty) return;

    state = ManageMediaLoadingState();

    final result = await _mediaRepository.getMedias();

    result.fold(
      (failure) => state = ManageMediaErrorState(failure),
      (medias) {
        this.medias = medias.asObservable();
        state = ManageMediaSuccessState();
      },
    );
  }

  @action
  Future<void> createMedia(MediaModel media) async {
    final result = await _mediaRepository.createMedia(media);

    result.fold(
      (failure) => state = ManageMediaErrorState(failure),
      (_) {
        medias.add(media);
        state = ManageMediaSuccessState(message: 'Mídia criada com sucesso');
      },
    );
  }

  @action
  Future<void> deleteMedia(MediaModel media) async {
    final result = await _mediaRepository.deleteMedia(media);

    result.fold(
      (failure) => state = ManageMediaErrorState(failure),
      (_) {
        medias.remove(media);
        state = ManageMediaSuccessState(message: 'Mídia deletada com sucesso');
      },
    );
  }
}
