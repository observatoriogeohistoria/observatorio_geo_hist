import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/danger_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_selection_area.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Returns `true` only when the person confirms; Cancel, Esc and clicking outside return `false`.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmText = 'Excluir',
  IconData? confirmIcon = Icons.delete_outline,
  String cancelText = 'Cancelar',
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: cancelText,
    barrierColor: AppTheme.colors.footerBackground
        .withValues(alpha: AppTheme.dimensions.components.panelDrawerScrimOpacity),
    builder: (context) => AppSelectionArea(
      child: ConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        confirmIcon: confirmIcon,
        cancelText: cancelText,
      ),
    ),
  );

  return confirmed ?? false;
}

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    this.confirmIcon,
    super.key,
  });

  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final IconData? confirmIcon;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);

    return Dialog(
      backgroundColor: colors.page,
      surfaceTintColor: Colors.transparent,
      insetPadding: EdgeInsets.all(AppTheme.dimensions.spacing.s16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r16),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: components.confirmDialogWidth),
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: title,
          child: Padding(
            padding: EdgeInsets.all(components.confirmDialogPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(title, style: styles.panelDialogTitle.copyWith(color: colors.ink)),
                ),
                SizedBox(height: components.confirmDialogTextGap),
                Text(message, style: styles.regular.copyWith(color: colors.inkSecondary)),
                SizedBox(height: components.confirmDialogActionsTop),
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    spacing: components.confirmDialogActionsGap,
                    runSpacing: components.confirmDialogActionsGap,
                    children: [
                      SecondaryButton.small(
                        text: cancelText,
                        autofocus: true,
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      DangerButton.small(
                        text: confirmText,
                        leadingIcon: confirmIcon,
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
