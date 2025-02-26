import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class SidebarHeader extends StatelessWidget {
  const SidebarHeader({
    required this.isCollapsed,
    super.key,
  });

  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    double padding = isCollapsed
        ? AppTheme(context).dimensions.space.small
        : AppTheme(context).dimensions.space.medium;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Image.asset(
        '${AppAssets.images}/${isCollapsed ? 'lupa.png' : 'logo.png'}',
        width: double.infinity,
      ),
    );
  }
}
