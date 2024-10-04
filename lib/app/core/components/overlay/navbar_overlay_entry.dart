import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/models/navbutton_item.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

OverlayEntry navbarOverlayEntry({
  required Offset buttonPosition,
  required Size buttonSize,
  required List<NavButtonItem> options,
  required VoidCallback removeOverlay,
}) {
  return OverlayEntry(
    builder: (context) => Positioned(
      top: buttonPosition.dy + buttonSize.height + 8,
      left: buttonPosition.dx,
      child: Material(
        elevation: 4,
        child: Container(
            width: 200,
            decoration: BoxDecoration(
              color: AppTheme.colors.white,
              borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.medium),
            ),
            child: Column(
              children: [
                for (final option in options)
                  ListTile(
                    title: Text(option.title),
                    onTap: () {
                      removeOverlay();
                      Navigator.of(context).pushNamed(option.route);
                    },
                  ),
              ],
            )),
      ),
    ),
  );
}
