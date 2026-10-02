import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.tooltip,
    this.size = 24,
    this.focusNode,
    super.key,
  });

  final IconData icon;
  final Color color;
  final void Function() onPressed;

  final String tooltip;
  final double size;

  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final minTarget = AppTheme.dimensions.components.minTapTarget;

    return AppFocusRing(
      borderRadius: BorderRadius.circular(minTarget),
      child: IconButton(
        tooltip: tooltip,
        focusNode: focusNode,
        padding: EdgeInsets.all(AppTheme.dimensions.space.small.scale),
        constraints: BoxConstraints(minWidth: minTarget, minHeight: minTarget),
        iconSize: size.scale,
        icon: Icon(icon, color: color, size: size.scale),
        onPressed: onPressed,
      ),
    );
  }
}
