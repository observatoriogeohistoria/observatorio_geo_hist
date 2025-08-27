import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class SidebarHeader extends StatelessWidget {
  const SidebarHeader({
    required this.isCollapsed,
    super.key,
  });

  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    double padding =
        isCollapsed ? AppTheme.dimensions.space.small : AppTheme.dimensions.space.medium;

    return Padding(
      padding: EdgeInsets.all(padding.scale),
      child: Image.asset(
        '${AppAssets.images}/${isCollapsed ? 'lupa.webp' : 'logo.webp'}',
        width: double.infinity,
      ),
    );
  }
}
