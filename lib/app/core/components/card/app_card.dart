import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/mouse_region/app_mouse_region.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class AppCard extends StatefulWidget {
  const AppCard({
    required this.child,
    this.width = double.infinity,
    this.padding,
    this.margin = EdgeInsets.zero,
    this.borderColor,
    this.borderRadius,
    this.isHover = false,
    super.key,
  });

  final Widget child;
  final double width;

  final EdgeInsets? padding;
  final EdgeInsets margin;

  final Color? borderColor;
  final double? borderRadius;

  final bool isHover;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool isHovered = false;

  BorderSide get border => BorderSide(color: widget.borderColor ?? AppTheme.colors.line);

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
                horizontal: AppTheme.dimensions.spacing.s16,
                vertical: AppTheme.dimensions.spacing.s8,
              ),
          margin: widget.margin,
          decoration: BoxDecoration(
            color: AppTheme.colors.page,
            borderRadius:
                BorderRadius.circular(widget.borderRadius ?? AppTheme.dimensions.radii.r12),
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
            color: AppTheme.colors.accent,
            size: AppTheme.dimensions.components.cardHoverIcon,
          ),
      ],
    );
  }
}
