import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Visible texts stay out of semantics: the control announces [semanticLabel] and
/// [semanticHint] on its own node.
class FormFieldFrame extends StatelessWidget {
  const FormFieldFrame({
    super.key,
    required this.label,
    required this.child,
    this.isOptional = false,
    this.helperText,
    this.errorText,
  });

  final String label;
  final Widget child;
  final bool isOptional;
  final String? helperText;
  final String? errorText;

  static String semanticLabel(String label, {bool isOptional = false}) =>
      isOptional ? '$label, opcional' : label;

  static String? semanticHint({String? error, String? helper}) {
    final parts = [error, helper].whereType<String>();
    return parts.isEmpty ? null : parts.join('. ');
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final helper = helperText;
    final error = errorText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ExcludeSemantics(
          child: Text.rich(
            TextSpan(
              text: label,
              children: [
                if (isOptional)
                  TextSpan(
                    text: ' opcional',
                    style: styles.formOptional.copyWith(color: colors.inkSecondary),
                  ),
              ],
            ),
            style: styles.formLabel.copyWith(color: colors.ink),
          ),
        ),
        SizedBox(height: components.formFieldLabelGap),
        child,
        if (helper != null) ...[
          SizedBox(height: components.formFieldLabelGap),
          ExcludeSemantics(
            child: Text(helper, style: styles.formHint.copyWith(color: colors.inkSecondary)),
          ),
        ],
        if (error != null) ...[
          SizedBox(height: components.formFieldLabelGap),
          ExcludeSemantics(
            child: Text(
              error,
              maxLines: components.formErrorMaxLines,
              overflow: TextOverflow.ellipsis,
              style: styles.formError.copyWith(color: colors.error),
            ),
          ),
        ],
      ],
    );
  }
}
