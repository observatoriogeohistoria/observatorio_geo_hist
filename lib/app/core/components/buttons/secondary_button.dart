import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_button_base.dart';

export 'package:observatorio_geo_hist/app/core/components/buttons/app_button_base.dart' show ButtonSize;

class SecondaryButton extends StatelessWidget {
  const SecondaryButton.small({
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
    this.trailingIcon,
    this.leadingIcon,
    this.reserveTexts = const [],
    super.key,
  }) : size = ButtonSize.small;

  const SecondaryButton.medium({
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
    this.trailingIcon,
    this.leadingIcon,
    this.reserveTexts = const [],
    super.key,
  }) : size = ButtonSize.medium;

  const SecondaryButton.big({
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
    this.trailingIcon,
    this.leadingIcon,
    this.reserveTexts = const [],
    super.key,
  }) : size = ButtonSize.big;

  final String text;
  final void Function() onPressed;
  final ButtonSize size;
  final bool isDisabled;

  /// Ícone opcional depois do texto (decorativo).
  final IconData? trailingIcon;

  /// Ícone opcional antes do texto (decorativo).
  final IconData? leadingIcon;

  /// Textos alternativos que reservam a largura do maior (ver `AppButtonBase`).
  final List<String> reserveTexts;

  @override
  Widget build(BuildContext context) {
    return AppButtonBase(
      kind: AppButtonKind.secondary,
      size: size,
      text: text,
      onPressed: onPressed,
      isDisabled: isDisabled,
      trailingIcon: trailingIcon,
      leadingIcon: leadingIcon,
      reserveTexts: reserveTexts,
    );
  }
}
