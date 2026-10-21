import 'dart:math';

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class Messenger {
  static void showError(BuildContext context, String message) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;

    _show(
      context,
      message: message,
      icon: Icons.error_outline,
      background: colors.error,
      iconColor: colors.white,
      duration: components.toastErrorDuration,
      fullWidth: true,
    );
  }

  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.check_circle_outline,
      background: AppTheme.colors.ink,
      iconColor: AppTheme.colors.toastIcon,
      duration: AppTheme.dimensions.components.toastDuration,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.info_outline,
      background: AppTheme.colors.ink,
      iconColor: AppTheme.colors.white,
      duration: AppTheme.dimensions.components.toastDuration,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color background,
    required Color iconColor,
    required Duration duration,
    bool fullWidth = false,
  }) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final style = AppTheme.typography.of(context).toast.copyWith(color: colors.white);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final maxWidth = min(components.toastMaxWidth, screenWidth - 2 * components.toastMargin);
    final chrome = 2 * components.toastPaddingH + components.toastIcon + components.toastIconGap;

    // O SnackBar flutuante só centraliza com largura fixa; medir o texto deixa a caixa do
    // tamanho da mensagem, como um aviso curto.
    final painter = TextPainter(
      text: TextSpan(text: message, style: style),
      textDirection: TextDirection.ltr,
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    final width = fullWidth ? maxWidth : min(maxWidth, painter.width + chrome + 1);
    painter.dispose();

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        width: width,
        duration: duration,
        backgroundColor: background,
        padding: EdgeInsets.symmetric(
          horizontal: components.toastPaddingH,
          vertical: components.toastPaddingV,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r12),
        ),
        showCloseIcon: fullWidth,
        closeIconColor: colors.white,
        content: Row(
          children: [
            Icon(icon, size: components.toastIcon, color: iconColor),
            SizedBox(width: components.toastIconGap),
            Expanded(child: Text(message, style: style)),
          ],
        ),
      ),
    );
  }
}
