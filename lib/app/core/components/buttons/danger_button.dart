import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_button_base.dart';

export 'package:observatorio_geo_hist/app/core/components/buttons/app_button_base.dart'
    show ButtonSize;

class DangerButton extends StatelessWidget {
  const DangerButton.small({
    required this.text,
    required this.onPressed,
    this.leadingIcon,
    this.isLoading = false,
    super.key,
  }) : size = ButtonSize.small;

  const DangerButton.medium({
    required this.text,
    required this.onPressed,
    this.leadingIcon,
    this.isLoading = false,
    super.key,
  }) : size = ButtonSize.medium;

  final String text;
  final void Function() onPressed;
  final ButtonSize size;

  final IconData? leadingIcon;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AppButtonBase(
      kind: AppButtonKind.danger,
      size: size,
      text: text,
      onPressed: onPressed,
      leadingIcon: leadingIcon,
      isLoading: isLoading,
    );
  }
}
