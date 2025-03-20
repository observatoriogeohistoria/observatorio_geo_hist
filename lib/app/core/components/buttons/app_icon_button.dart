import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    this.size = 24,
    super.key,
  });

  final IconData icon;
  final Color color;
  final void Function() onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.all(AppTheme.dimensions.space.small.scale),
      constraints: const BoxConstraints(),
      iconSize: size.scale,
      icon: Icon(icon, color: color, size: size.scale),
      onPressed: onPressed,
    );
  }
}
