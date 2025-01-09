import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return AppTheme.colors.orange.withValues(alpha: 0.8);
          }
          return AppTheme.colors.orange;
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.small),
          ),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: AppTheme.dimensions.space.large,
            vertical: AppTheme.dimensions.space.medium,
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: AppTheme.typography.title.medium.copyWith(
          color: AppTheme.colors.white,
        ),
      ),
    );
  }
}
