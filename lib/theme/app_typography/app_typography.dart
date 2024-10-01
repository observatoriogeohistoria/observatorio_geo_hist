part of '../app_theme.dart';

class AppTypography {
  const AppTypography._();

  static const TypographyStyle headline = TypographyStyle._(
    small: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    medium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    large: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
  );

  static const TypographyStyle body = TypographyStyle._(
    small: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    medium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    large: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: Colors.black,
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
