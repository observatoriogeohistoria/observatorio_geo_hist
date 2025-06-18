import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton.small({
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
    super.key,
  }) : size = ButtonSize.small;

  const PrimaryButton.medium({
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
    super.key,
  }) : size = ButtonSize.medium;

  const PrimaryButton.big({
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
    super.key,
  }) : size = ButtonSize.big;

  final String text;
  final void Function() onPressed;
  final ButtonSize size;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry padding;
    AppTitle buttonText;
    Color buttonTextColor = isDisabled ? AppTheme.colors.gray : AppTheme.colors.white;

    switch (size) {
      case ButtonSize.small:
        padding = EdgeInsets.symmetric(
          horizontal: AppTheme.dimensions.space.small.horizontalSpacing,
          vertical: AppTheme.dimensions.space.medium.verticalSpacing,
        );

        buttonText = AppTitle.small(
          text: text,
          textAlign: TextAlign.center,
          color: buttonTextColor,
          notSelectable: true,
        );

        break;
      case ButtonSize.medium:
        padding = EdgeInsets.all(AppTheme.dimensions.space.medium.scale);

        buttonText = AppTitle.medium(
          text: text,
          textAlign: TextAlign.center,
          color: buttonTextColor,
          notSelectable: true,
        );

        break;
      case ButtonSize.big:
        padding = EdgeInsets.all(AppTheme.dimensions.space.medium.scale);

        buttonText = AppTitle.big(
          text: text,
          textAlign: TextAlign.center,
          color: buttonTextColor,
          notSelectable: true,
        );

        break;
    }

    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (isDisabled) {
            return AppTheme.colors.lighterGray;
          }
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
      onPressed: isDisabled ? null : onPressed,
      child: buttonText,
    );
  }
}

enum ButtonSize { small, medium, big }
