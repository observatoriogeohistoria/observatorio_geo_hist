import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/mouse_region/app_mouse_region.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    required this.icon,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    bool isMobile = ScreenUtils.isMobile(context);

    return AppMouseRegion(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding:
              isMobile ? EdgeInsets.zero : EdgeInsets.all(AppTheme.dimensions.space.small.scale),
          decoration: BoxDecoration(
            color: AppTheme.colors.orange.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.small),
          ),
          child: Center(
            child: Icon(
              icon,
              color: AppTheme.colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
