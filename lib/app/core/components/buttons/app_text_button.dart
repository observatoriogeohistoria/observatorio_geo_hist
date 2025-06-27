import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/mouse_region/app_mouse_region.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_label.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class AppTextButton extends StatefulWidget {
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
  State<AppTextButton> createState() => _AppTextButtonState();
}

class _AppTextButtonState extends State<AppTextButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry padding;
    AppLabel buttonText;
    Color buttonTextColor =
        (widget.isDisabled || _isHovering) ? AppTheme.colors.gray : AppTheme.colors.orange;

    switch (widget.size) {
      case ButtonSize.small:
        padding = EdgeInsets.all(AppTheme.dimensions.space.small.scale);

        buttonText = AppLabel.small(
          text: widget.text,
          textAlign: TextAlign.center,
          color: buttonTextColor,
          notSelectable: true,
        );

        break;
      case ButtonSize.medium:
        padding = EdgeInsets.all(AppTheme.dimensions.space.medium.scale);

        buttonText = AppLabel.medium(
          text: widget.text,
          textAlign: TextAlign.center,
          color: buttonTextColor,
          notSelectable: true,
        );

        break;
      case ButtonSize.big:
        padding = EdgeInsets.all(AppTheme.dimensions.space.medium.scale);

        buttonText = AppLabel.big(
          text: widget.text,
          textAlign: TextAlign.center,
          color: buttonTextColor,
          notSelectable: true,
        );

        break;
    }

    return AppMouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.isDisabled ? null : widget.onPressed,
        child: Padding(
          padding: padding,
          child: buttonText,
        ),
      ),
    );
  }
}

enum ButtonSize { small, medium, big }
