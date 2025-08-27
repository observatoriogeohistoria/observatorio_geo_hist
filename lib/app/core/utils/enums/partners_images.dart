import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
import 'package:observatorio_geo_hist/app/core/utils/strings/strings.dart';

enum PartnersImages {
  capes,
  cnpq,
  faced,
  fapemig,
  ppged,
  proexc,
  propp,
  ufu;

  /// The path of the image.
  String get path {
    return '${AppAssets.partners}/${convertToSnakeCase(name)}.webp';
  }
}
