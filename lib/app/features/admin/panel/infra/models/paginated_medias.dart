import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/media_model.dart';

class PaginatedMedias {
  final List<MediaModel> medias;
  final String? nextPageToken;

  PaginatedMedias({
    required this.medias,
    required this.nextPageToken,
  });

  bool get hasMore => nextPageToken != null;
}
