import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/scroll/no_scroll_configuration.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class AppScrollbar extends StatelessWidget {
  const AppScrollbar({
    required this.child,
    required this.controller,
    super.key,
  });

  final Widget child;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller: controller,
      thumbVisibility: true,
      trackVisibility: false,
      thickness: AppTheme.dimensions.space.small.horizontalSpacing,
      radius: Radius.circular(AppTheme.dimensions.radius.small),
      thumbColor: AppTheme.colors.lightOrange.withValues(alpha: 0.35),
      child: NoScrollConfiguration(
        child: Padding(
          padding: EdgeInsets.only(right: AppTheme.dimensions.space.medium.horizontalSpacing),
          child: child,
        ),
      ),
    );
  }
}
