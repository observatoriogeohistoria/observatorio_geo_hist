import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class Messenger {
  static showError(
    BuildContext context,
    String message,
  ) {
    _show(context, message, AppTheme.colors.error);
  }

  static showSuccess(
    BuildContext context,
    String message,
  ) {
    _show(context, message, AppTheme.colors.success);
  }

  static showInfo(
    BuildContext context,
    String message,
  ) {
    _show(context, message, AppTheme.colors.info);
  }

  static void _show(BuildContext context, String message, Color background) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTheme.typography.of(context).small.copyWith(color: AppTheme.colors.white),
        ),
        backgroundColor: background,
      ),
    );
  }
}
