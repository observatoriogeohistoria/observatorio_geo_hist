import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton.small({
    required this.text,
    required this.onPressed,
    super.key,
  }) : size = ButtonSize.small;

  const SecondaryButton.medium({
    required this.text,
    required this.onPressed,
    super.key,
  }) : size = ButtonSize.medium;

  const SecondaryButton.big({
    required this.text,
    required this.onPressed,
    super.key,
  }) : size = ButtonSize.big;

  final String text;
  final void Function() onPressed;
  final ButtonSize size;

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry padding;

    switch (size) {
      case ButtonSize.small:
        padding = EdgeInsets.symmetric(
          horizontal: AppTheme(context).dimensions.space.small,
          vertical: AppTheme(context).dimensions.space.medium,
        );
        break;
      case ButtonSize.medium:
        padding = EdgeInsets.symmetric(
          horizontal: AppTheme(context).dimensions.space.medium,
          vertical: AppTheme(context).dimensions.space.medium,
        );
        break;
      case ButtonSize.big:
        padding = EdgeInsets.symmetric(
          horizontal: AppTheme(context).dimensions.space.medium,
          vertical: AppTheme(context).dimensions.space.medium,
        );
        break;
    }

    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return AppTheme(context).colors.lightGray.withValues(alpha: 0.2);
          }
          return AppTheme(context).colors.white;
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            side: BorderSide(color: AppTheme(context).colors.orange),
            borderRadius: BorderRadius.circular(AppTheme(context).dimensions.radius.small),
          ),
        ),
        padding: WidgetStateProperty.all(padding),
      ),
      onPressed: onPressed,
      child: AppTitle.big(
        text: text,
        color: AppTheme(context).colors.orange,
      ),
    );
  }
}

enum ButtonSize { small, medium, big }
