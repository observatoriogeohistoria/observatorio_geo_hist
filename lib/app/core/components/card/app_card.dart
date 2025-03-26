import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.width = double.infinity,
    this.padding,
    this.margin = EdgeInsets.zero,
    this.borderColor,
    super.key,
  });

  final Widget child;
  final double width;

  final EdgeInsets? padding;
  final EdgeInsets margin;

  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(color: borderColor ?? AppTheme.colors.lightGray);

    return Container(
      width: width,
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: AppTheme.dimensions.space.medium.horizontalSpacing,
            vertical: AppTheme.dimensions.space.small.verticalSpacing,
          ),
      margin: margin,
      decoration: BoxDecoration(
        color: AppTheme.colors.white,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.large),
        border: Border(
          top: border,
          left: border,
          right: border,
          bottom: border.copyWith(width: AppTheme.dimensions.stroke.huge),
        ),
      ),
      child: child,
    );
  }
}
