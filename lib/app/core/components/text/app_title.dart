import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class AppTitle extends StatelessWidget {
  const AppTitle.small({
    required this.text,
    required this.color,
    this.textAlign = TextAlign.start,
    this.notSelectable = false,
    super.key,
  }) : size = TypographySize.small;

  const AppTitle.medium({
    required this.text,
    required this.color,
    this.textAlign = TextAlign.start,
    this.notSelectable = false,
    super.key,
  }) : size = TypographySize.medium;

  const AppTitle.big({
    required this.text,
    required this.color,
    this.textAlign = TextAlign.start,
    this.notSelectable = false,
    super.key,
  }) : size = TypographySize.big;

  final String text;
  final Color color;
  final TextAlign textAlign;
  final TypographySize size;
  final bool notSelectable;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle;

    switch (size) {
      case TypographySize.small:
        textStyle = AppTheme.typography.title.small;
        break;
      case TypographySize.medium:
        textStyle = AppTheme.typography.title.medium;
        break;
      case TypographySize.big:
        textStyle = AppTheme.typography.title.big;
        break;
    }

    return notSelectable
        ? Text(
            text,
            textAlign: textAlign,
            style: textStyle.copyWith(
              color: color,
            ),
          )
        : SelectableText(
            text,
            textAlign: textAlign,
            style: textStyle.copyWith(
              color: color,
            ),
          );
  }
}
