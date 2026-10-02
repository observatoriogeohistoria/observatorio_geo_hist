import 'package:firebase_storage/firebase_storage.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/core/utils/environment/app_environment.dart';
import 'package:observatorio_geo_hist/app/core/utils/generator/id_generator.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/media_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/paginated_medias.dart';

abstract class MediaDatasource {
  Future<PaginatedMedias> getMedias({int pageSize = 20, String? pageToken});
  Future<MediaModel> createMedia(MediaModel media);
  Future<void> deleteMedia(MediaModel media);
}

class MediaDatasourceImpl implements MediaDatasource {
  final FirebaseStorage _storage;
  final LoggerService _loggerService;

  MediaDatasourceImpl(this._storage, this._loggerService);

  @override
  Future<PaginatedMedias> getMedias({int pageSize = 20, String? pageToken}) async {
    if (!AppEnvironment.current.hasStorage) {
      return PaginatedMedias(medias: [], nextPageToken: null);
    }

    try {
      final ListResult result =
          await _storage.ref('media').list(ListOptions(maxResults: pageSize, pageToken: pageToken));

      final medias = await Future.wait(result.items.map((ref) async {
        int lastUnderscoreIndex = ref.name.lastIndexOf('_');
        String name = ref.name.substring(0, lastUnderscoreIndex);
        String id = ref.name.substring(lastUnderscoreIndex + 1).split('.').first;
        String extension = ref.name.split('.').last;
        String url = await ref.getDownloadURL();

        // Os bytes não são baixados na listagem: o preview usa a url.
        return MediaModel(id: id, name: name, extension: extension, url: url);
      }));

      return PaginatedMedias(medias: medias, nextPageToken: result.nextPageToken);
    } catch (exception, stackTrace) {
      _loggerService.error('Error getting medias: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<MediaModel> createMedia(MediaModel media) async {
    try {
      _ensureStorage();
      if (media.bytes == null) throw Exception('Media bytes is required');

      String id = IdGenerator.generate();
      String fileName = '${media.name}_$id';

      final ref = _storage.ref('media/$fileName.${media.extension}');
      await ref.putData(media.bytes!);

      String url = await ref.getDownloadURL();

      return media.copyWith(id: id, url: url);
    } catch (exception, stackTrace) {
      _loggerService.error('Error creating media: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteMedia(MediaModel media) async {
    try {
      _ensureStorage();
      if (media.id == null) throw Exception('Media ID is required');

      final ref = _storage.ref('media/${media.name}_${media.id}.${media.extension}');
      await ref.delete();
    } catch (exception, stackTrace) {
      _loggerService.error('Error deleting media: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }

  void _ensureStorage() {
    if (!AppEnvironment.current.hasStorage) {
      throw UnsupportedError('Storage desabilitado no ambiente de dev');
    }
  }
}
