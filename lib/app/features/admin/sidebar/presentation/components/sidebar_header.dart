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
    final spacing = AppTheme.dimensions.spacing;

    return Padding(
      padding: EdgeInsets.all(isCollapsed ? spacing.s8 : spacing.s16),
      child: Image.asset(
        '${AppAssets.images}/${isCollapsed ? 'lupa.webp' : 'logo.webp'}',
        width: double.infinity,
      ),
    );
  }
}
