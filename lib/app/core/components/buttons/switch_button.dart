import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class SwitchButton extends StatefulWidget {
  const SwitchButton({
    required this.title,
    required this.onChanged,
    this.initialValue = false,
    this.isDisabled = false,
    super.key,
  });

  final String title;
  final void Function(bool) onChanged;
  final bool initialValue;
  final bool isDisabled;

  @override
  State<SwitchButton> createState() => _SwitchStateButton();
}

class _SwitchStateButton extends State<SwitchButton> {
  bool value = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppTitle.small(
            text: widget.title,
            color: AppTheme.colors.darkGray,
          ),
        ),
        Switch(
          value: value,
          onChanged: (value) {
            if (widget.isDisabled) return;

            setState(() => this.value = value);
            widget.onChanged(value);
          },
          activeColor: AppTheme.colors.orange,
        ),
      ],
    );
  }
}
