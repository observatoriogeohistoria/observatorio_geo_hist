import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.width = double.infinity,
    this.padding,
    super.key,
  });

  final Widget child;
  final double width;

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(color: AppTheme(context).colors.lightGray);

    return Container(
      width: width,
      padding: padding ?? EdgeInsets.all(AppTheme(context).dimensions.space.small),
      decoration: BoxDecoration(
        color: AppTheme(context).colors.white,
        borderRadius: BorderRadius.circular(AppTheme(context).dimensions.radius.large),
        border: Border(
          top: border,
          left: border,
          right: border,
          bottom: border.copyWith(width: 4),
        ),
      ),
      child: child,
    );
  }
}
