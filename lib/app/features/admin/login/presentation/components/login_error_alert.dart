import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LoginErrorAlert extends StatelessWidget {
  const LoginErrorAlert({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;

    return Semantics(
      liveRegion: true,
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.errorSurface,
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r12),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: components.loginAlertPaddingH,
            vertical: components.loginAlertPaddingV,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExcludeSemantics(
                child: Icon(
                  Icons.error_outline,
                  size: components.loginAlertIcon,
                  color: colors.error,
                ),
              ),
              SizedBox(width: components.loginAlertGap),
              Expanded(
                child: Text(
                  message,
                  style: AppTheme.typography.of(context).formError.copyWith(color: colors.error),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
