import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_button_base.dart';

export 'package:observatorio_geo_hist/app/core/components/buttons/app_button_base.dart'
    show ButtonSize;

class PrimaryButton extends StatelessWidget {
  const PrimaryButton.small({
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
    this.trailingIcon,
    super.key,
  }) : size = ButtonSize.small;

  const PrimaryButton.medium({
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
    this.trailingIcon,
    super.key,
  }) : size = ButtonSize.medium;

  const PrimaryButton.big({
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
    this.trailingIcon,
    super.key,
  }) : size = ButtonSize.big;

  final String text;
  final void Function() onPressed;
  final ButtonSize size;
  final bool isDisabled;

  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return AppButtonBase(
      kind: AppButtonKind.primary,
      size: size,
      text: text,
      onPressed: onPressed,
      isDisabled: isDisabled,
      trailingIcon: trailingIcon,
    );
  }
}
