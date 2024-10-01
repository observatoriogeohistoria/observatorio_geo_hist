library app_theme;

import 'package:flutter/material.dart';

part 'app_colors/app_colors.dart';
part 'app_typography/app_typography.dart';
part 'app_dimensions/app_dimensions.dart';

class AppTheme {
  static const AppColors colors = AppColors._();
  static const AppTypography typography = AppTypography._();
  static const AppDimensions dimensions = AppDimensions._();
}
