import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton.small({
    required this.text,
    required this.onPressed,
    super.key,
  }) : size = ButtonSize.small;

  const PrimaryButton.medium({
    required this.text,
    required this.onPressed,
    super.key,
  }) : size = ButtonSize.medium;

  const PrimaryButton.big({
    required this.text,
    required this.onPressed,
    super.key,
  }) : size = ButtonSize.big;

  final String text;
  final void Function() onPressed;
  final ButtonSize size; // Define o tamanho do botão

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry padding;

    switch (size) {
      case ButtonSize.small:
        padding = EdgeInsets.symmetric(
          horizontal: AppTheme.dimensions.space.xsmall,
          vertical: AppTheme.dimensions.space.xsmall,
        );
        break;
      case ButtonSize.medium:
        padding = EdgeInsets.symmetric(
          horizontal: AppTheme.dimensions.space.medium,
          vertical: AppTheme.dimensions.space.medium,
        );
        break;
      case ButtonSize.big:
        padding = EdgeInsets.symmetric(
          horizontal: AppTheme.dimensions.space.medium,
          vertical: AppTheme.dimensions.space.medium,
        );
        break;
    }

    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return AppTheme.colors.orange.withValues(alpha: 0.8);
          }
          return AppTheme.colors.orange;
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.small),
          ),
        ),
        padding: WidgetStateProperty.all(padding),
      ),
      onPressed: onPressed,
      child: AppTitle.big(
        text: text,
        color: AppTheme.colors.white,
      ),
    );
  }
}

enum ButtonSize { small, medium, big }
