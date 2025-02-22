import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';

class AppBody extends StatelessWidget {
  const AppBody({
    required this.text,
    required this.color,
    this.textAlign = TextAlign.start,
    super.key,
  });

  final String text;
  final Color color;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    bool isMobile = DeviceUtils.isMobile(context);
    bool isTablet = DeviceUtils.isTablet(context);

    double fontSize;
    if (isMobile) {
      fontSize = 14;
    } else if (isTablet) {
      fontSize = 16;
    } else {
      fontSize = 18;
    }

    double letterSpacing = 0.5;
    double height = 1.5;
    FontWeight fontWeight = FontWeight.normal;

    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.dosis(
        fontSize: fontSize,
        letterSpacing: letterSpacing,
        height: height,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
