part of '../app_theme.dart';

class AppTypography {
  AppTypography(BuildContext context) {
    isMobile = DeviceUtils.isMobile(context);
    isTablet = DeviceUtils.isTablet(context);
  }

  late final bool isMobile;
  late final bool isTablet;

  TypographyStyle get headline => _createTypographyStyle(
        {TypographySize.small: 30, TypographySize.medium: 36, TypographySize.big: 40},
        {TypographySize.small: -0.25, TypographySize.medium: 0, TypographySize.big: 0},
        FontWeight.w800,
      );

  TypographyStyle get title => _createTypographyStyle(
        {TypographySize.small: 18, TypographySize.medium: 22, TypographySize.big: 26},
        {TypographySize.small: -0.25, TypographySize.medium: -0.25, TypographySize.big: -0.25},
        FontWeight.w600,
      );

  TypographyStyle get body => _createTypographyStyle(
        {TypographySize.small: 16, TypographySize.medium: 18, TypographySize.big: 22},
        {TypographySize.small: 0.35, TypographySize.medium: 0.35, TypographySize.big: 0.2},
        FontWeight.w500,
      );

  TypographyStyle get label => _createTypographyStyle(
        {TypographySize.small: 12, TypographySize.medium: 14, TypographySize.big: 18},
        {TypographySize.small: 0.35, TypographySize.medium: 0.2, TypographySize.big: 0.2},
        FontWeight.w600,
      );

  TypographyStyle _createTypographyStyle(
    Map<TypographySize, double> baseSizes,
    Map<TypographySize, double> spacing,
    FontWeight weight,
  ) {
    return TypographyStyle._(
      small: _textStyle(TypographySize.small, baseSizes, spacing, weight),
      medium: _textStyle(TypographySize.medium, baseSizes, spacing, weight),
      big: _textStyle(TypographySize.big, baseSizes, spacing, weight),
    );
  }

  double _getFontSize(TypographySize size, Map<TypographySize, double> baseSizes) {
    double baseFontSize = baseSizes[size] ?? 14;

    if (isMobile) {
      return baseFontSize - 2;
    } else if (isTablet) {
      return baseFontSize;
    } else {
      return baseFontSize + 2;
    }
  }

  TextStyle _textStyle(
    TypographySize size,
    Map<TypographySize, double> baseSizes,
    Map<TypographySize, double> spacing,
    FontWeight weight,
  ) {
    double fontSize = _getFontSize(size, baseSizes);
    double letterSpacing = spacing[size] ?? 0.2;

    return GoogleFonts.dosis(
      fontSize: fontSize,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      height: (fontSize + 6) / fontSize,
    );
  }
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
