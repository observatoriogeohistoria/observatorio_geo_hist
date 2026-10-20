import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// A linha inteira alterna, para o título e a dica serem área de clique e um só ponto no Tab.
class PanelSwitchField extends StatelessWidget {
  const PanelSwitchField({
    required this.title,
    required this.hint,
    required this.value,
    required this.onChanged,
    this.focusNode,
    super.key,
  });

  final String title;
  final String hint;
  final bool value;
  final ValueChanged<bool> onChanged;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r8);

    return MergeSemantics(
      child: AppFocusRing(
        borderRadius: radius,
        child: InkWell(
          focusNode: focusNode,
          onTap: () => onChanged(!value),
          borderRadius: radius,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: styles.panelChoiceTitle.copyWith(color: colors.ink)),
                    SizedBox(height: components.panelSwitchHintGap),
                    Text(hint, style: styles.formHint.copyWith(color: colors.inkSecondary)),
                  ],
                ),
              ),
              SizedBox(width: components.panelSwitchGap),
              ExcludeFocus(
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  activeTrackColor: colors.accent,
                  activeThumbColor: colors.white,
                  inactiveTrackColor: colors.fieldBorder,
                  inactiveThumbColor: colors.white,
                  trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
