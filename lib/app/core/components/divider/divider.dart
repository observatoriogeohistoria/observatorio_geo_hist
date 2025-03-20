import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({
    this.indent = 24,
    super.key,
  });

  final double? indent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppTheme.colors.gray.withValues(alpha: 0.5),
      thickness: 1,
      indent: indent,
      endIndent: indent,
    );
  }
}
