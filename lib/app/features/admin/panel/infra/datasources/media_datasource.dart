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

      final mediaFutures = result.items.map((ref) async {
        final metadata = await ref.getMetadata();
        final fileSize = metadata.size;

        int lastUnderscoreIndex = ref.name.lastIndexOf('_');
        String name = ref.name.substring(0, lastUnderscoreIndex);
        String id = ref.name.substring(lastUnderscoreIndex + 1).split('.').first;
        String extension = ref.name.split('.').last;
        String url = await ref.getDownloadURL();

        if (fileSize == null || fileSize > 10 * 1024 * 1024) {
          return MediaModel(id: id, name: name, extension: extension, bytes: null, url: url);
        } else {
          final bytes = await ref.getData();
          return MediaModel(id: id, name: name, extension: extension, bytes: bytes, url: url);
        }
      }).toList();

      medias = await Future.wait(mediaFutures);

      return medias;
    } catch (exception, stackTrace) {
      _loggerService.error('Error getting medias: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<MediaModel> createMedia(MediaModel media) async {
    try {
      if (media.bytes == null) throw Exception('Media bytes is required');

      String id = IdGenerator.generate();
      String fileName = '${media.name}_$id';

      final ref = _storage.refFromURL(_bucket).child('media/$fileName.${media.extension}');
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
      if (media.id == null) throw Exception('Media ID is required');

      final ref =
          _storage.refFromURL(_bucket).child('media/${media.name}_${media.id}.${media.extension}');
      await ref.delete();
    } catch (exception, stackTrace) {
      _loggerService.error('Error deleting media: $exception', stackTrace: stackTrace);
      rethrow;
    }
  }
}
