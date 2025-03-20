part of '../app_theme.dart';

class AppTypography {
  const AppTypography._();

  /// The singleton instance of the [AppTypography] class.
  static const AppTypography instance = AppTypography._();

  TypographyStyle get headline => TypographyStyle._(
        small: GoogleFonts.dosis(
          fontSize: 26.fontSize,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
          height: 1.3,
        ),
        medium: GoogleFonts.dosis(
          fontSize: 30.fontSize,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.15,
          height: 1.3,
        ),
        big: GoogleFonts.dosis(
          fontSize: 34.fontSize,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
          height: 1.3,
        ),
      );

  TypographyStyle get title => TypographyStyle._(
        small: GoogleFonts.dosis(
          fontSize: 18.fontSize,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          height: 1.4,
        ),
        medium: GoogleFonts.dosis(
          fontSize: 22.fontSize,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
          height: 1.4,
        ),
        big: GoogleFonts.dosis(
          fontSize: 26.fontSize,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          height: 1.4,
        ),
      );

  TypographyStyle get body => TypographyStyle._(
        small: GoogleFonts.dosis(
          fontSize: 16.fontSize,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
          height: 1.5,
        ),
        medium: GoogleFonts.dosis(
          fontSize: 18.fontSize,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.25,
          height: 1.5,
        ),
        big: GoogleFonts.dosis(
          fontSize: 22.fontSize,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.25,
          height: 1.5,
        ),
      );

  TypographyStyle get label => TypographyStyle._(
        small: GoogleFonts.dosis(
          fontSize: 12.fontSize,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          height: 1.4,
        ),
        medium: GoogleFonts.dosis(
          fontSize: 14.fontSize,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.25,
          height: 1.4,
        ),
        big: GoogleFonts.dosis(
          fontSize: 18.fontSize,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          height: 1.4,
        ),
      );
}

class TypographyStyle {
  const TypographyStyle._({
    required this.small,
    required this.medium,
    required this.big,
  });

  final TextStyle small;
  final TextStyle medium;
  final TextStyle big;
}

enum TypographySize { small, medium, big }
