import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar_categories_menu.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar_location.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/stores/fetch_categories_store.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class NavbarMobileMenu extends StatefulWidget {
  const NavbarMobileMenu({super.key, required this.store, required this.location});

  final FetchCategoriesStore store;

  final NavbarLocation location;

  @override
  State<NavbarMobileMenu> createState() => _NavbarMobileMenuState();
}

class _NavbarMobileMenuState extends State<NavbarMobileMenu> {
  late final Set<NavbarSection> _expanded = {
    if (widget.location.section == NavbarSection.history ||
        widget.location.section == NavbarSection.geography)
      widget.location.section!,
  };

  void _close() => Navigator.of(context).pop();

  void _goTo(String route) {
    final router = GoRouter.of(context);
    _close();
    widget.store.setSelectedCategory(null);
    router.go(route);
  }

  void _toggle(NavbarSection section) {
    setState(
        () => _expanded.contains(section) ? _expanded.remove(section) : _expanded.add(section));
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final spacing = AppTheme.dimensions.spacing;
    final width = MediaQuery.sizeOf(context).width;

    return CallbackShortcuts(
      bindings: {const SingleActivator(LogicalKeyboardKey.escape): _close},
      child: Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: width < components.mobileMenuMaxWidth ? width : components.mobileMenuMaxWidth,
          height: double.infinity,
          child: DecoratedBox(
            decoration:
                BoxDecoration(color: colors.page, boxShadow: AppTheme.dimensions.shadows.elevated),
            child: Material(
              type: MaterialType.transparency,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: spacing.s20, right: spacing.s8),
                      child: SizedBox(
                        height: components.navbarHeight,
                        child: Row(
                          children: [
                            Expanded(
                                child: Text('Menu', style: AppTheme.typography.of(context).h3)),
                            AppIconButton(
                              tooltip: 'Fechar menu',
                              icon: Icons.close,
                              color: colors.ink,
                              onPressed: _close,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(height: 1, thickness: 1, color: colors.line),
                    Expanded(
                      child: SingleChildScrollView(
                        padding:
                            EdgeInsets.symmetric(horizontal: spacing.s20, vertical: spacing.s8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _PanelRow(
                              label: 'Sobre',
                              isActive: widget.location.section == NavbarSection.about,
                              onTap: () => _goTo(AppRoutes.root),
                            ),
                            _areaSection(PostsAreas.history, NavbarSection.history),
                            _areaSection(PostsAreas.geography, NavbarSection.geography),
                            _PanelRow(
                              label: 'Biblioteca',
                              isActive: widget.location.section == NavbarSection.library,
                              onTap: () => _goTo(AppRoutes.library),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _areaSection(PostsAreas area, NavbarSection section) {
    final isExpanded = _expanded.contains(section);
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : AppTheme.dimensions.components.menuAnimation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PanelRow(
          label: area.portuguese,
          isActive: widget.location.section == section,
          isExpandable: true,
          isExpanded: isExpanded,
          onTap: () => _toggle(section),
        ),
        AnimatedSize(
          duration: duration,
          curve: Curves.easeOut,
          alignment: Alignment.topCenter,
          child: isExpanded
              ? Container(
                  margin: EdgeInsets.only(bottom: AppTheme.dimensions.spacing.s8),
                  padding: EdgeInsets.all(AppTheme.dimensions.spacing.s8),
                  decoration: BoxDecoration(
                    color: AppTheme.colors.surface,
                    borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r12),
                  ),
                  child: NavbarCategoriesMenu(
                    area: area,
                    store: widget.store,
                    selectedCategoryKey: widget.location.categoryKeyFor(area),
                    onSelected: _close,
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

class _PanelRow extends StatelessWidget {
  const _PanelRow({
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.isExpandable = false,
    this.isExpanded = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final bool isExpandable;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r8);
    final color = isActive ? colors.accent : colors.ink;

    return Semantics(
      button: true,
      selected: isActive,
      expanded: isExpandable ? isExpanded : null,
      label: label,
      onTap: onTap,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          mouseCursor: SystemMouseCursors.click,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: components.minTapTarget),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.s4, vertical: spacing.s12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: AppTheme.typography.of(context).regular.copyWith(
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                    ),
                  ),
                  if (isExpandable)
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      size: components.menuIconSize,
                      color: color,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
