part of '../app_theme.dart';

class AppTypography {
  const AppTypography._();

  static const AppTypography instance = AppTypography._();

  AppTextStyles of(BuildContext context) {
    return AppTextStyles.forWidth(MediaQuery.sizeOf(context).width);
  }
}
