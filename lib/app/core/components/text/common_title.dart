import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class CommonTitle extends StatelessWidget {
  const CommonTitle({
    required this.title,
    this.color,
    super.key,
  });

  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.dimensions.space.large.horizontalSpacing,
      ),
      child: AppHeadline.big(
        text: title,
        color: color ?? AppTheme.colors.white,
      ),
    );
  }
}
