import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_text_button.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LibraryActiveFilter {
  const LibraryActiveFilter(this.label, this.onRemove);

  final String label;
  final VoidCallback onRemove;
}

class LibraryActiveFilters extends StatelessWidget {
  const LibraryActiveFilters({super.key, required this.filters, required this.onClearAll});

  final List<LibraryActiveFilter> filters;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Filtros ativos',
      child: Wrap(
        spacing: components.libraryActiveRowGap,
        runSpacing: components.libraryActiveRowGap,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (final filter in filters) _ActiveChip(filter: filter),
          AppTextButton.small(text: 'Limpar tudo', onPressed: onClearAll),
        ],
      ),
    );
  }
}

class _ActiveChip extends StatelessWidget {
  const _ActiveChip({required this.filter});

  final LibraryActiveFilter filter;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final pill = BorderRadius.circular(AppTheme.dimensions.radii.pill);

    return Container(
      padding: EdgeInsetsDirectional.only(
        start: components.libraryActiveChipPaddingStart,
        end: components.libraryActiveChipPaddingEnd,
        top: components.libraryActiveChipPaddingV,
        bottom: components.libraryActiveChipPaddingV,
      ),
      decoration: BoxDecoration(
        color: colors.accentSoft,
        borderRadius: pill,
        border: Border.all(color: colors.accentSoftBorder, width: AppTheme.dimensions.stroke.small),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              filter.label,
              style: AppTheme.typography.of(context).chip.copyWith(color: colors.accentStrong),
            ),
          ),
          SizedBox(width: components.libraryActiveChipRemoveGap),
          Semantics(
            button: true,
            label: 'Remover filtro ${filter.label}',
            onTap: filter.onRemove,
            excludeSemantics: true,
            child: AppFocusRing(
              borderRadius: pill,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: filter.onRemove,
                  customBorder: const CircleBorder(),
                  hoverColor: colors.accentSoftBorder,
                  splashFactory: NoSplash.splashFactory,
                  child: SizedBox.square(
                    dimension: components.libraryActiveChipRemove,
                    child: Icon(
                      Icons.close,
                      size: components.libraryActiveChipRemoveIcon,
                      color: colors.accentStrong,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
