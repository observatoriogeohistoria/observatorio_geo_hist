import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/datasources/media/media_datasource.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/errors/media_failures.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/media_model.dart';

abstract class MediaRepository {
  Future<Either<Failure, List<MediaModel>>> getMedias();
  Future<Either<Failure, MediaModel>> createMedia(MediaModel media);
  Future<Either<Failure, Unit>> deleteMedia(MediaModel media);
}

class MediaRepositoryImpl implements MediaRepository {
  final MediaDatasource _mediaDatasource;

  MediaRepositoryImpl(this._mediaDatasource);

  @override
  Future<Either<Failure, List<MediaModel>>> getMedias() async {
    try {
      final medias = await _mediaDatasource.getMedias();
      return Right(medias);
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure.fromException(error));
    } catch (error) {
      return const Left(GetMediaFailure());
    }
  }

  @override
  Future<Either<Failure, MediaModel>> createMedia(MediaModel media) async {
    try {
      final newMedia = await _mediaDatasource.createMedia(media);
      return Right(newMedia);
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure.fromException(error));
    } catch (error) {
      return const Left(CreateOrUpdateMediaFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMedia(MediaModel media) async {
    try {
      await _mediaDatasource.deleteMedia(media);
      return const Right(unit);
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure.fromException(error));
    } catch (error) {
      return const Left(DeleteMediaFailure());
    }
  }
}
