import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
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
    Color buttonTextColor =
        isDisabled ? AppTheme(context).colors.gray : AppTheme(context).colors.white;

    switch (size) {
      case ButtonSize.small:
        padding = EdgeInsets.symmetric(
          horizontal: AppTheme(context).dimensions.space.small,
          vertical: AppTheme(context).dimensions.space.medium,
        );

        buttonText = AppTitle.small(
          text: text,
          color: buttonTextColor,
        );

        break;
      case ButtonSize.medium:
        padding = EdgeInsets.symmetric(
          horizontal: AppTheme(context).dimensions.space.medium,
          vertical: AppTheme(context).dimensions.space.medium,
        );

        buttonText = AppTitle.medium(
          text: text,
          color: buttonTextColor,
        );

        break;
      case ButtonSize.big:
        padding = EdgeInsets.symmetric(
          horizontal: AppTheme(context).dimensions.space.medium,
          vertical: AppTheme(context).dimensions.space.medium,
        );

        buttonText = AppTitle.big(
          text: text,
          color: buttonTextColor,
        );

        break;
    }

    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (isDisabled) {
            return AppTheme(context).colors.lightGray;
          }
          if (states.contains(WidgetState.hovered)) {
            return AppTheme(context).colors.orange.withValues(alpha: 0.8);
          }
          return AppTheme(context).colors.orange;
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme(context).dimensions.radius.small),
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
