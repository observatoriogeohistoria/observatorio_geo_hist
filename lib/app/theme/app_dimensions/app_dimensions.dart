part of '../app_theme.dart';

class AppDimensions {
  AppDimensions._();
  static AppDimensions get instance => AppDimensions._();

  DimensionStyle space = const DimensionStyle._(
    small: 8.0,
    medium: 16.0,
    large: 24.0,
  );

  DimensionStyle borderRadius = const DimensionStyle._(
    small: 4.0,
    medium: 8.0,
    large: 12.0,
  );

  DimensionStyle stroke = const DimensionStyle._(
    small: 1.0,
    medium: 2.0,
    large: 3.0,
  );
}

class DimensionStyle {
  const DimensionStyle._({
    required this.small,
    required this.medium,
    required this.large,
  });

  final double small;
  final double medium;
  final double large;
}
