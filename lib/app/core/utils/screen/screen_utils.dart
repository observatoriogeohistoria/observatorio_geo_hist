import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

enum Breakpoint {
  mobile,
  tablet,
  desktop;

  static const double tabletMinWidth = 600;
  static const double desktopMinWidth = 1024;

  static Breakpoint fromWidth(double width) {
    if (width >= desktopMinWidth) return Breakpoint.desktop;
    if (width >= tabletMinWidth) return Breakpoint.tablet;
    return Breakpoint.mobile;
  }
}

class ScreenUtils {
  static const double contentMaxWidth = 1120;

  static Breakpoint breakpointOf(BuildContext context) {
    return Breakpoint.fromWidth(MediaQuery.sizeOf(context).width);
  }

  static double contentMargin(Breakpoint breakpoint) {
    return switch (breakpoint) {
      Breakpoint.mobile => AppTheme.dimensions.spacing.s20,
      Breakpoint.tablet || Breakpoint.desktop => AppTheme.dimensions.spacing.s32,
    };
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }
}
