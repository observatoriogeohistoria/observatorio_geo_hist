import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_text_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/loading/linear_loading.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PanelListFooter extends StatelessWidget {
  const PanelListFooter({
    this.onClearFilters,
    this.onLoadMore,
    this.isLoadingMore = false,
    super.key,
  });

  final VoidCallback? onClearFilters;

  /// Without it, the next items arrive on scroll and the footer only shows the indicator.
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;

  static bool isNeeded({
    VoidCallback? onClearFilters,
    VoidCallback? onLoadMore,
    bool isLoadingMore = false,
  }) {
    return onClearFilters != null || onLoadMore != null || isLoadingMore;
  }

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final onClearFilters = this.onClearFilters;
    final onLoadMore = this.onLoadMore;
    final showProgress = isLoadingMore && onLoadMore == null;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: components.panelListFootMinHeight),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: components.panelListFootPaddingH,
          vertical: components.panelListFootPaddingV,
        ),
        child: Row(
          children: [
            Expanded(
              child: showProgress
                  ? Semantics(label: 'Carregando mais itens', child: const LinearLoading())
                  : const SizedBox.shrink(),
            ),
            if (onClearFilters != null || onLoadMore != null)
              Wrap(
                spacing: AppTheme.dimensions.spacing.s8,
                runSpacing: AppTheme.dimensions.spacing.s8,
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (onClearFilters != null)
                    AppTextButton.small(text: 'Limpar filtros', onPressed: onClearFilters),
                  if (onLoadMore != null)
                    SecondaryButton.small(
                      text: isLoadingMore ? 'Carregando...' : 'Carregar mais',
                      reserveTexts: const ['Carregar mais', 'Carregando...'],
                      isDisabled: isLoadingMore,
                      onPressed: onLoadMore,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
