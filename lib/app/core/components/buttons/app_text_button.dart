import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_button_base.dart';

export 'package:observatorio_geo_hist/app/core/components/buttons/app_button_base.dart'
    show ButtonSize;

class AppTextButton extends StatelessWidget {
  const AppTextButton.small({
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
    super.key,
  }) : size = ButtonSize.small;

  const AppTextButton.medium({
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
    super.key,
  }) : size = ButtonSize.medium;

  const AppTextButton.big({
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
    return AppButtonBase(
      kind: AppButtonKind.ghost,
      size: size,
      text: text,
      onPressed: onPressed,
      isDisabled: isDisabled,
    );
  }
}
