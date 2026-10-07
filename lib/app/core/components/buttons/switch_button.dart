import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/field/panel_field_decoration.dart';
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
  bool _value = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ExcludeSemantics(
            child: Text(widget.title, style: PanelFieldDecoration.textStyle(context)),
          ),
        ),
        Semantics(
          label: widget.title,
          child: Switch(
            value: _value,
            onChanged: (value) {
              if (widget.isDisabled) return;

              setState(() => _value = value);
              widget.onChanged(value);
            },
            activeThumbColor: AppTheme.colors.page,
            activeTrackColor: AppTheme.colors.accent,
          ),
        ),
      ],
    );
  }
}
