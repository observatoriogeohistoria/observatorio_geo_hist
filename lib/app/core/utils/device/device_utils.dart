import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class DeviceUtils {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isSmallMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 400;
  }

  static bool isTablet(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1024;
  }

  static bool isLaptop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024 && MediaQuery.of(context).size.width < 1200;
  }

  static bool isSmallDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }

  static double getPageHorizontalPadding(BuildContext context) {
    return ((isSmallDesktop(context) || isTablet(context))
            ? AppTheme.dimensions.space.gigantic
            : isDesktop(context)
                ? (2 * AppTheme.dimensions.space.gigantic)
                : AppTheme.dimensions.space.large)
        .horizontalSpacing;
  }
}
