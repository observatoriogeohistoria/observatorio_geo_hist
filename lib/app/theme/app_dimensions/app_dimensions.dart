part of '../app_theme.dart';

class AppDimensions {
  AppDimensions._();
  static AppDimensions get instance => AppDimensions._();

  DimensionStyle space = const DimensionStyle._(
    mini: 4.0,
    small: 8.0,
    medium: 16.0,
    large: 24.0,
    huge: 32.0,
    massive: 48.0,
    gigantic: 96.0,
  );

  DimensionStyle radius = const DimensionStyle._(
    mini: 2.0,
    small: 4.0,
    medium: 8.0,
    large: 12.0,
    huge: 24.0,
    massive: 48.0,
    gigantic: double.infinity,
  );

  DimensionStyle stroke = const DimensionStyle._(
    mini: 0.5,
    small: 1.0,
    medium: 2.0,
    large: 3.0,
    huge: 4.0,
    massive: 5.0,
    gigantic: 6.0,
  );
}

class DimensionStyle {
  const DimensionStyle._({
    required this.mini,
    required this.small,
    required this.medium,
    required this.large,
    required this.huge,
    required this.massive,
    required this.gigantic,
  });

  final double mini;
  final double small;
  final double medium;
  final double large;
  final double huge;
  final double massive;
  final double gigantic;
}
