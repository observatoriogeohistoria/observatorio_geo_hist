import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Dialogs and side panels open on another route, outside the page's area, and need their own.
class AppSelectionArea extends StatelessWidget {
  const AppSelectionArea({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DefaultSelectionStyle.merge(
      selectionColor: AppTheme.colors.textSelection,
      child: SelectionArea(child: child),
    );
  }
}
