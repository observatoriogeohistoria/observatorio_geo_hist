import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class AppLabel extends StatelessWidget {
  const AppLabel.small({
    required this.text,
    required this.color,
    this.textAlign = TextAlign.start,
    super.key,
  }) : size = TypographySize.small;

  const AppLabel.medium({
    required this.text,
    required this.color,
    this.textAlign = TextAlign.start,
    super.key,
  }) : size = TypographySize.medium;

  const AppLabel.big({
    required this.text,
    required this.color,
    this.textAlign = TextAlign.start,
    super.key,
  }) : size = TypographySize.big;

  final String text;
  final Color color;
  final TextAlign textAlign;
  final TypographySize size;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle;

    switch (size) {
      case TypographySize.small:
        textStyle = AppTheme.typography.label.small;
        break;
      case TypographySize.medium:
        textStyle = AppTheme.typography.label.medium;
        break;
      case TypographySize.big:
        textStyle = AppTheme.typography.label.big;
        break;
    }

    return Text(
      text,
      textAlign: textAlign,
      style: textStyle.copyWith(
        color: color,
      ),
    );
  }
}
