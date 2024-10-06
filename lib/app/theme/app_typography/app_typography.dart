part of '../app_theme.dart';

class AppTypography {
  AppTypography._();
  static AppTypography get instance => AppTypography._();

  static const fontFamily = 'Dosis';

  TypographyStyle headline = const TypographyStyle._(
    small: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: fontFamily,
    ),
    medium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      fontFamily: fontFamily,
    ),
    large: TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w600,
      fontFamily: fontFamily,
    ),
  );

  TypographyStyle body = const TypographyStyle._(
    small: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: fontFamily,
    ),
    medium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: fontFamily,
    ),
    large: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      fontFamily: fontFamily,
    ),
  );
}

class TypographyStyle {
  const TypographyStyle._({
    required this.small,
    required this.medium,
    required this.large,
  });

  final TextStyle small;
  final TextStyle medium;
  final TextStyle large;
}
