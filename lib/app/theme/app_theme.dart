library app_theme;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';

part 'app_colors/app_colors.dart';
part 'app_dimensions/app_dimensions.dart';
part 'app_typography/app_typography.dart';

class AppTheme {
  static AppTheme? _instance;

  factory AppTheme(BuildContext context) {
    return _instance ??= AppTheme._(context);
  }

  AppTheme._(this.context);

  late final BuildContext context;

  static AppColors colors = AppColors.instance;
  static AppDimensions dimensions = AppDimensions.instance;

  AppTypography get typography => AppTypography(context);
}
