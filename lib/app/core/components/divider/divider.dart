import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({
    this.color,
    super.key,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color ?? AppTheme.colors.line,
      thickness: AppTheme.dimensions.stroke.small,
    );
  }
}
