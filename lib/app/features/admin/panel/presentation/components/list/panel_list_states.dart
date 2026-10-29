import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/state_message_box.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Nothing created yet; the create button only shows for those who can.
class PanelEmptyInfo {
  const PanelEmptyInfo({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.actionIcon = Icons.add,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final IconData actionIcon;
  final VoidCallback? onAction;
}

class PanelEmptyState extends StatelessWidget {
  const PanelEmptyState({required this.info, super.key});

  final PanelEmptyInfo info;

  @override
  Widget build(BuildContext context) {
    final label = info.actionLabel;
    final onAction = info.onAction;

    return _PanelStateFrame(
      child: StateMessageBox(
        icon: info.icon,
        title: info.title,
        message: info.message,
        action: label == null || onAction == null
            ? null
            : PrimaryButton.small(text: label, leadingIcon: info.actionIcon, onPressed: onAction),
      ),
    );
  }
}

class PanelNoResultsState extends StatelessWidget {
  const PanelNoResultsState({required this.onClearFilters, super.key});

  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return _PanelStateFrame(
      child: StateMessageBox(
        icon: Icons.search,
        title: 'Nada encontrado com esses filtros',
        message: 'Tente outro termo ou limpe os filtros.',
        action: SecondaryButton.small(text: 'Limpar filtros', onPressed: onClearFilters),
      ),
    );
  }
}

class PanelErrorState extends StatelessWidget {
  const PanelErrorState({required this.message, required this.onRetry, super.key});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return _PanelStateFrame(
      child: StateMessageBox(
        icon: Icons.close,
        tone: StateMessageTone.error,
        title: 'Não foi possível carregar',
        message: message,
        action: PrimaryButton.small(text: 'Tentar de novo', onPressed: onRetry),
      ),
    );
  }
}

class _PanelStateFrame extends StatelessWidget {
  const _PanelStateFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.colors.page,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r18),
      ),
      child: child,
    );
  }
}
