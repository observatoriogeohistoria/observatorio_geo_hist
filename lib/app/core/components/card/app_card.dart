import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/mouse_region/app_mouse_region.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class AppCard extends StatefulWidget {
  const AppCard({
    required this.child,
    this.width = double.infinity,
    this.padding,
    this.margin = EdgeInsets.zero,
    this.borderColor,
    this.isHover = false,
    super.key,
  });

  final Widget child;
  final double width;

  final EdgeInsets? padding;
  final EdgeInsets margin;

  final Color? borderColor;
  final bool isHover;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool isHovered = false;

  BorderSide get border => BorderSide(color: widget.borderColor ?? AppTheme.colors.lighterGray);

  @override
  Widget build(BuildContext context) {
    if (widget.isHover) {
      return AppMouseRegion(
        child: _card,
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
      );
    }

    return _card;
  }

  Widget get _card {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: widget.width,
          padding: widget.padding ??
              EdgeInsets.symmetric(
                horizontal: AppTheme.dimensions.space.medium.horizontalSpacing,
                vertical: AppTheme.dimensions.space.small.verticalSpacing,
              ),
          margin: widget.margin,
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
          child: widget.child,
        ),
        if (isHovered)
          Icon(
            Icons.touch_app,
            color: AppTheme.colors.orange,
            size: 56.scale,
          ),
      ],
    );
  }
}
