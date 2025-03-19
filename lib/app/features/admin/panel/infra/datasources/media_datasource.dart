import 'package:firebase_storage/firebase_storage.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/core/utils/generator/id_generator.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/media_model.dart';

abstract class MediaDatasource {
  Future<List<MediaModel>> getMedias();
  Future<MediaModel> createMedia(MediaModel media);
  Future<void> deleteMedia(MediaModel media);
}

class MediaDatasourceImpl implements MediaDatasource {
  final FirebaseStorage _storage;
  final LoggerService _loggerService;

  MediaDatasourceImpl(this._storage, this._loggerService);

  static String get _bucket => 'gs://observatorio-geo-hist.firebasestorage.app';

  @override
  Future<List<MediaModel>> getMedias() async {
    try {
      List<MediaModel> medias = [];

      final ListResult result = await _storage.refFromURL(_bucket).child('media').listAll();
      for (final ref in result.items) {
        final bytes = await ref.getData();
        if (bytes == null) continue;

        String name = ref.name.split('_').first;
        String extension = ref.name.split('.').last;
        String url = await ref.getDownloadURL();

        medias.add(MediaModel(name: name, extension: extension, bytes: bytes, url: url));
      }

      return medias;
    } catch (exception, stackTrace) {
      _loggerService.error('Error getting medias: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<MediaModel> createMedia(MediaModel media) async {
    try {
      String id = IdGenerator.generate();
      String fileName = '${media.name}_$id';

      final ref = _storage.refFromURL(_bucket).child('media/$fileName.${media.extension}');
      await ref.putData(media.bytes);

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
      if (media.id == null) throw Exception('Media ID is required');

      final ref = _storage.refFromURL(_bucket).child('media/${media.name}_${media.id}.jpg');
      await ref.delete();
    } catch (exception, stackTrace) {
      _loggerService.error('Error deleting media: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }
}
