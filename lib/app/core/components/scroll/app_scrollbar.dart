import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/scroll/no_scroll_configuration.dart';
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
    final components = AppTheme.dimensions.components;

    return RawScrollbar(
      controller: controller,
      thumbVisibility: true,
      trackVisibility: false,
      thickness: components.scrollbarThickness,
      radius: Radius.circular(AppTheme.dimensions.radii.pill),
      thumbColor: AppTheme.colors.accentSoftBorder,
      child: NoScrollConfiguration(
        child: Padding(
          padding: EdgeInsets.only(right: components.scrollbarInset),
          child: child,
        ),
      ),
    );
  }
}
