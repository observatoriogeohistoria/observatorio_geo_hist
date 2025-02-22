import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';

class AppHeadline extends StatelessWidget {
  const AppHeadline.small({
    required this.text,
    required this.color,
    this.textAlign = TextAlign.center,
    super.key,
  }) : type = AppHeadlineType.small;

  const AppHeadline.medium({
    required this.text,
    required this.color,
    this.textAlign = TextAlign.center,
    super.key,
  }) : type = AppHeadlineType.medium;

  const AppHeadline.big({
    required this.text,
    required this.color,
    this.textAlign = TextAlign.center,
    super.key,
  }) : type = AppHeadlineType.big;

  final String text;
  final Color color;
  final TextAlign textAlign;
  final AppHeadlineType type;

  @override
  Widget build(BuildContext context) {
    double letterSpacing = 0.5;
    double height = 1.2;
    FontWeight fontWeight = FontWeight.bold;

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

    if (type == AppHeadlineType.small) {
      baseFontSize = 30;
    } else if (type == AppHeadlineType.medium) {
      baseFontSize = 36;
    } else if (type == AppHeadlineType.big) {
      baseFontSize = 40;
    }

    if (isMobile) {
      return baseFontSize - 6;
    } else if (isTablet) {
      return baseFontSize;
    } else {
      return baseFontSize + 4;
    }
  }
}

enum AppHeadlineType { small, medium, big }
