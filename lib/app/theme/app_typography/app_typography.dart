part of '../app_theme.dart';

class AppTypography {
  AppTypography._();
  static AppTypography get instance => AppTypography._();

  static const fontFamily = 'Dosis';

  TypographyStyle headline = TypographyStyle._(
    small: GoogleFonts.dosis(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.25,
      height: 30 / 24,
    ),
    medium: GoogleFonts.dosis(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      letterSpacing: 0,
      height: 31 / 32,
    ),
    large: GoogleFonts.dosis(
      fontSize: 36,
      fontWeight: FontWeight.w800,
      letterSpacing: 0,
      height: 42 / 36,
    ),
  );

  TypographyStyle title = TypographyStyle._(
    small: GoogleFonts.dosis(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.25,
      height: 20 / 18,
    ),
    medium: GoogleFonts.dosis(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.25,
      height: 22 / 22,
    ),
    large: GoogleFonts.dosis(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.25,
      height: 28 / 24,
    ),
  );

  TypographyStyle body = TypographyStyle._(
    small: GoogleFonts.dosis(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.35,
      height: 20 / 16,
    ),
    medium: GoogleFonts.dosis(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
      height: 22 / 18,
    ),
    large: GoogleFonts.dosis(
      fontSize: 22,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.2,
      height: 24 / 22,
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
