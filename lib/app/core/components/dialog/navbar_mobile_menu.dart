import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/full_screen_dialog.dart';
import 'package:observatorio_geo_hist/app/core/components/scroll/no_scroll_configuration.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/navbutton_item.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Full screen mobile menu. Items with sub options expand in place (accordion).
class NavbarMobileMenu extends StatefulWidget {
  const NavbarMobileMenu({
    required this.navButtonItens,
    required this.onItemSelected,
    this.categorySelected,
    super.key,
  });

  final List<NavButtonItem> navButtonItens;

  /// Called after the menu is closed, with the tapped item.
  final void Function(NavButtonItem item) onItemSelected;
  final CategoryModel? categorySelected;

  @override
  State<NavbarMobileMenu> createState() => _NavbarMobileMenuState();
}

class _NavbarMobileMenuState extends State<NavbarMobileMenu> {
  NavButtonItem? _expanded;

  @override
  void initState() {
    super.initState();
    final selectedArea = widget.categorySelected?.areas.firstOrNull;
    if (selectedArea != null) {
      _expanded = widget.navButtonItens.where((item) => item.area == selectedArea).firstOrNull;
    }
  }

  void _select(NavButtonItem item) {
    if (item.isDisabled) return;
    Navigator.of(context).pop();
    widget.onItemSelected(item);
  }

  @override
  Widget build(BuildContext context) {
    return FullScreenDialog(
      child: NoScrollConfiguration(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: AppTheme.dimensions.space.large.verticalSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final item in widget.navButtonItens)
                _MobileSection(
                  item: item,
                  isExpanded: item == _expanded,
                  selectedCategory: widget.categorySelected,
                  onHeaderTap: () {
                    if (item.options?.isEmpty ?? true) {
                      _select(item);
                      return;
                    }
                    setState(() => _expanded = item == _expanded ? null : item);
                  },
                  onOptionTap: _select,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileSection extends StatelessWidget {
  const _MobileSection({
    required this.item,
    required this.isExpanded,
    required this.selectedCategory,
    required this.onHeaderTap,
    required this.onOptionTap,
  });

  final NavButtonItem item;
  final bool isExpanded;
  final CategoryModel? selectedCategory;
  final VoidCallback onHeaderTap;
  final void Function(NavButtonItem) onOptionTap;

  @override
  Widget build(BuildContext context) {
    final options = item.options ?? const <NavButtonItem>[];
    final hasOptions = options.isNotEmpty;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.colors.white.withValues(alpha: 0.3)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onHeaderTap,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppTheme.dimensions.space.medium.verticalSpacing,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.title.toUpperCase(),
                      style: AppTheme.typography.headline.medium.copyWith(
                        color: AppTheme.colors.white,
                      ),
                    ),
                  ),
                  if (hasOptions)
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppTheme.colors.white,
                        size: 32,
                      ),
                    ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: isExpanded && hasOptions
                ? Padding(
                    padding: EdgeInsets.only(
                      bottom: AppTheme.dimensions.space.medium.verticalSpacing,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.large),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final option in options)
                            _MobileOption(
                              option: option,
                              isSelected:
                                  option.category != null && option.category == selectedCategory,
                              onTap: () => onOptionTap(option),
                            ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _MobileOption extends StatelessWidget {
  const _MobileOption({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final NavButtonItem option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppTheme.colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.medium),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.dimensions.space.medium.scale,
            vertical: AppTheme.dimensions.space.small.verticalSpacing,
          ),
          child: Text(
            option.title,
            style: AppTheme.typography.title.medium.copyWith(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppTheme.colors.orange : AppTheme.colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
