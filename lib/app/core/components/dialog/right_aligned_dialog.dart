import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class RightAlignedDialog extends StatelessWidget {
  const RightAlignedDialog({
    required this.child,
    this.width,
    this.widthFollowsContent = false,
    super.key,
  });

  final Widget child;

  final double? width;
  final bool widthFollowsContent;

  @override
  Widget build(BuildContext context) {
    double getWidth() {
      final isMobile = DeviceUtils.isMobile(context);
      final isTablet = DeviceUtils.isTablet(context);

      if (isMobile) {
        return MediaQuery.of(context).size.width;
      } else if (isTablet) {
        return MediaQuery.of(context).size.width * 0.7;
      } else {
        return MediaQuery.of(context).size.width * 0.5;
      }
    }

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: AppTheme.colors.lightGray,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppTheme.dimensions.radius.large),
          bottomLeft: Radius.circular(AppTheme.dimensions.radius.large),
        ),
        child: Container(
          width: widthFollowsContent ? null : (width ?? getWidth()),
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(AppTheme.dimensions.space.large),
          child: child,
        ),
      ),
    );
  }
}
