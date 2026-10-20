import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/components/form/form_field_frame.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PanelChoice<T> {
  const PanelChoice(this.value, this.title, this.description);

  final T value;
  final String title;
  final String description;
}

/// Escolha única em cartões. O `RadioGroup` dá a navegação de rádio: Tab entra uma vez no
/// grupo e as setas trocam a opção.
class PanelChoiceCards<T> extends StatelessWidget {
  const PanelChoiceCards({
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
    this.validator,
    this.formFieldKey,
    this.focusNode,
    this.enabled = true,
    super.key,
  });

  final String label;
  final List<PanelChoice<T>> options;
  final T? value;
  final ValueChanged<T> onChanged;
  final String? Function(T?)? validator;
  final GlobalKey<FormFieldState<T>>? formFieldKey;

  /// Vai para o primeiro cartão.
  final FocusNode? focusNode;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final gap = AppTheme.dimensions.components.panelChoicesGap;

    return FormField<T>(
      key: formFieldKey,
      initialValue: value,
      validator: (_) => validator?.call(value),
      builder: (field) {
        final error = field.errorText;

        void select(T? choice) {
          if (!enabled || choice == null) return;
          onChanged(choice);
          field.didChange(choice);
        }

        return Semantics(
          container: true,
          explicitChildNodes: true,
          label: label,
          hint: FormFieldFrame.semanticHint(error: error),
          child: FormFieldFrame(
            label: label,
            errorText: error,
            child: RadioGroup<T>(
              groupValue: value,
              onChanged: select,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (index, option) in options.indexed) ...[
                    if (index > 0) SizedBox(height: gap),
                    _ChoiceCard<T>(
                      option: option,
                      selected: option.value == value,
                      hasError: error != null,
                      focusNode: index == 0 ? focusNode : null,
                      onTap: enabled ? () => select(option.value) : null,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ChoiceCard<T> extends StatelessWidget {
  const _ChoiceCard({
    required this.option,
    required this.selected,
    required this.hasError,
    this.focusNode,
    this.onTap,
  });

  final PanelChoice<T> option;
  final bool selected;
  final bool hasError;
  final FocusNode? focusNode;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r12);
    final borderColor = selected
        ? colors.accent
        : hasError
            ? colors.error
            : colors.line;

    return MergeSemantics(
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          color: selected ? colors.accentSoft : colors.page,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(color: borderColor, width: components.formFieldBorder),
          ),
          child: InkWell(
            canRequestFocus: false,
            onTap: onTap,
            customBorder: RoundedRectangleBorder(borderRadius: radius),
            hoverColor: selected ? Colors.transparent : colors.surface,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: components.panelChoicePaddingH,
                vertical: components.panelChoicePaddingV,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox.square(
                    dimension: components.panelRadioSize,
                    child: Radio<T>(
                      value: option.value,
                      focusNode: focusNode,
                      enabled: onTap != null,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      fillColor: WidgetStateProperty.resolveWith(
                        (states) => states.contains(WidgetState.selected)
                            ? colors.accent
                            : colors.fieldBorder,
                      ),
                      // O cartão já mostra o foco e o passar do mouse.
                      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                    ),
                  ),
                  SizedBox(width: components.panelChoiceGap),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(option.title,
                            style: styles.panelChoiceTitle.copyWith(color: colors.ink)),
                        Text(
                          option.description,
                          style: styles.formHint.copyWith(color: colors.inkSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
