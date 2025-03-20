library app_theme;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';

part 'app_colors/app_colors.dart';
part 'app_dimensions/app_dimensions.dart';
part 'app_typography/app_typography.dart';

class AppTheme {
  const AppTheme._();

  static AppColors get colors => AppColors.instance;
  static AppDimensions get dimensions => AppDimensions.instance;
  static AppTypography get typography => AppTypography.instance;
}
