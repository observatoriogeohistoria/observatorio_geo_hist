import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/mouse_region/app_mouse_region.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class ToggleCollpaseButton extends StatelessWidget {
  const ToggleCollpaseButton({
    required this.onTap,
    required this.isCollapsed,
    super.key,
  });

  final VoidCallback onTap;
  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    final icon = isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios;

    return AppMouseRegion(
      child: GestureDetector(
        onTap: onTap,
        child: Align(
          alignment: isCollapsed ? Alignment.center : Alignment.centerRight,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: AppTheme(context).dimensions.space.medium,
              horizontal: AppTheme(context).dimensions.space.small,
            ),
            child: Icon(icon, color: AppTheme(context).colors.darkGray, size: 32),
          ),
        ),
      ),
    );
  }
}
