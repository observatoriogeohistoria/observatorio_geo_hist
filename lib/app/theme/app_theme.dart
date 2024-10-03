library app_theme;

import 'package:flutter/material.dart';

part 'app_colors/app_colors.dart';
part 'app_dimensions/app_dimensions.dart';
part 'app_typography/app_typography.dart';

class AppTheme {
  static AppColors colors = AppColors.instance;
  static AppTypography typography = AppTypography.instance;
  static AppDimensions dimensions = AppDimensions.instance;
}
