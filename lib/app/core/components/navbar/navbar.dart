import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/app_setup.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/navbar_mobile_menu.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/components/logo/app_logo.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar_categories_menu.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar_dropdown.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar_item.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar_location.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/stores/fetch_categories_store.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  late final _fetchCategoriesStore = AppSetup.getIt.get<FetchCategoriesStore>();

  final _menuButtonFocus = FocusNode(debugLabel: 'Navbar menu button');

  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();

    _fetchCategoriesStore.fetchCategories();
  }

  @override
  void dispose() {
    _menuButtonFocus.dispose();
    super.dispose();
  }

  void _goTo(String route) {
    _fetchCategoriesStore.setSelectedCategory(null);
    GoRouter.of(context).go(route);
  }

  Future<void> _openMenu(NavbarLocation location) async {
    final components = AppTheme.dimensions.components;
    final duration =
        MediaQuery.disableAnimationsOf(context) ? Duration.zero : components.menuAnimation;

    setState(() => _isMenuOpen = true);

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Fechar menu',
      barrierColor: AppTheme.colors.ink.withValues(alpha: components.scrimOpacity),
      transitionDuration: duration,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: Offset.zero).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOut),
          ),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return NavbarMobileMenu(store: _fetchCategoriesStore, location: location);
      },
    );

    if (!mounted) return;
    setState(() => _isMenuOpen = false);
    _menuButtonFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final spacing = AppTheme.dimensions.spacing;
    final location = NavbarLocation.of(context);
    final isDesktop = ScreenUtils.breakpointOf(context) == Breakpoint.desktop;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.page.withValues(alpha: components.navbarOpacity),
            border: Border(bottom: BorderSide(color: colors.line)),
          ),
          child: PageContent(
            child: SizedBox(
              height: components.navbarHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppLogo(),
                  if (isDesktop)
                    Row(
                      children: [
                        NavbarItem(
                          label: 'Sobre',
                          isActive: location.section == NavbarSection.about,
                          onTap: () => _goTo(AppRoutes.root),
                        ),
                        SizedBox(width: spacing.s4),
                        _areaDropdown(PostsAreas.history, NavbarSection.history, location),
                        SizedBox(width: spacing.s4),
                        _areaDropdown(PostsAreas.geography, NavbarSection.geography, location),
                        SizedBox(width: spacing.s4),
                        NavbarItem(
                          label: 'Biblioteca',
                          isActive: location.section == NavbarSection.library,
                          onTap: () => _goTo(AppRoutes.library),
                        ),
                      ],
                    )
                  else
                    _MenuButton(
                      focusNode: _menuButtonFocus,
                      isOpen: _isMenuOpen,
                      onPressed: () => _openMenu(location),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _areaDropdown(PostsAreas area, NavbarSection section, NavbarLocation location) {
    return NavbarDropdown(
      label: area.portuguese,
      isActive: location.section == section,
      menuBuilder: (context, close) => NavbarCategoriesMenu(
        area: area,
        store: _fetchCategoriesStore,
        selectedCategoryKey: location.categoryKeyFor(area),
        onSelected: close,
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.focusNode, required this.isOpen, required this.onPressed});

  final FocusNode focusNode;
  final bool isOpen;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r10);
    final label = isOpen ? 'Fechar menu' : 'Abrir menu';

    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        expanded: isOpen,
        label: label,
        onTap: onPressed,
        excludeSemantics: true,
        child: AppFocusRing(
          borderRadius: radius,
          child: InkWell(
            focusNode: focusNode,
            borderRadius: radius,
            onTap: onPressed,
            mouseCursor: SystemMouseCursors.click,
            child: SizedBox(
              width: components.minTapTarget,
              height: components.minTapTarget,
              child: Icon(
                Icons.menu,
                size: components.menuIconSize,
                color: AppTheme.colors.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NavbarSliver extends StatelessWidget {
  const NavbarSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(pinned: true, delegate: _NavbarHeaderDelegate());
  }
}

class _NavbarHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => AppTheme.dimensions.components.navbarHeight;

  @override
  double get maxExtent => AppTheme.dimensions.components.navbarHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => const Navbar();

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
