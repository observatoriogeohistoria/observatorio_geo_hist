part of '../app_theme.dart';

class AppDimensions {
  AppDimensions._();
  static AppDimensions get instance => AppDimensions._();

  DimensionStyle space = const DimensionStyle._(
    xsmall: 4.0,
    small: 8.0,
    medium: 16.0,
    large: 24.0,
    xlarge: 32.0,
    xxlarge: 48.0,
  );

  DimensionStyle radius = const DimensionStyle._(
    xsmall: 2.0,
    small: 4.0,
    medium: 8.0,
    large: 12.0,
    xlarge: 24.0,
    xxlarge: 48.0,
  );

  DimensionStyle stroke = const DimensionStyle._(
    xsmall: 0.5,
    small: 1.0,
    medium: 2.0,
    large: 3.0,
    xlarge: 4.0,
    xxlarge: 5.0,
  );
}

class DimensionStyle {
  const DimensionStyle._({
    required this.xsmall,
    required this.small,
    required this.medium,
    required this.large,
    required this.xlarge,
    required this.xxlarge,
  });

  final double xsmall;
  final double small;
  final double medium;
  final double large;
  final double xlarge;
  final double xxlarge;
}
