import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppTheme(context).colors.gray.withValues(alpha: 0.5),
      thickness: 1,
      indent: AppTheme(context).dimensions.space.large,
      endIndent: AppTheme(context).dimensions.space.large,
    );
  }
}
