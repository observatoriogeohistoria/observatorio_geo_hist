import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';

class AppTitle extends StatelessWidget {
  const AppTitle.small({
    required this.text,
    required this.color,
    this.textAlign = TextAlign.start,
    super.key,
  }) : type = AppTitleType.small;

  const AppTitle.medium({
    required this.text,
    required this.color,
    this.textAlign = TextAlign.start,
    super.key,
  }) : type = AppTitleType.medium;

  const AppTitle.big({
    required this.text,
    required this.color,
    this.textAlign = TextAlign.start,
    super.key,
  }) : type = AppTitleType.big;

  final String text;
  final Color color;
  final TextAlign textAlign;
  final AppTitleType type;

  @override
  Widget build(BuildContext context) {
    double letterSpacing = 0.5;
    double height = 1.2;
    FontWeight fontWeight = FontWeight.w600;

    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.dosis(
        fontSize: fontSize(context),
        letterSpacing: letterSpacing,
        height: height,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }

  double fontSize(BuildContext context) {
    bool isMobile = DeviceUtils.isMobile(context);
    bool isTablet = DeviceUtils.isTablet(context);

    double baseFontSize = 0;

    if (type == AppTitleType.small) {
      baseFontSize = 18;
    } else if (type == AppTitleType.medium) {
      baseFontSize = 22;
    } else if (type == AppTitleType.big) {
      baseFontSize = 26;
    }

    if (isMobile) {
      return baseFontSize - 4;
    } else if (isTablet) {
      return baseFontSize;
    } else {
      return baseFontSize + 2;
    }
  }
}

enum AppTitleType { small, medium, big }
