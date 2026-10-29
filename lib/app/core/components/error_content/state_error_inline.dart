import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class StateErrorInline extends StatelessWidget {
  const StateErrorInline({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r16),
        border: Border.all(color: colors.line, width: AppTheme.dimensions.stroke.small),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.s24),
        child: Wrap(
          spacing: spacing.s16,
          runSpacing: spacing.s12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              message,
              style: AppTheme.typography.of(context).regular.copyWith(color: colors.inkSecondary),
            ),
            SecondaryButton.small(text: 'Tentar de novo', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
