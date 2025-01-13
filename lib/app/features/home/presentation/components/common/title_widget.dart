import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({
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
        horizontal: AppTheme.dimensions.space.large,
      ),
      child: Text(
        title,
        style: AppTheme.typography.headline.large.copyWith(
          color: color ?? AppTheme.colors.white,
        ),
      ),
    );
  }
}
