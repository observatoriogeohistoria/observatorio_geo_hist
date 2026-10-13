import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/admin/admin_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_state.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/panel_top_bar.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/categories_section.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/library_section.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/media_section.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/posts_section.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/team_section.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/users_section.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/panel_counts_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/components/sidebar_navigation.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/enums/sidebar_item.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/stores/sidebar_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PanelPage extends StatefulWidget {
  const PanelPage({
    required this.tab,
    this.postType,
    super.key,
  });

  final SidebarItem tab;
  final PostType? postType;

  @override
  State<PanelPage> createState() => _PanelPageState();
}

class _PanelPageState extends State<PanelPage> {
  late final _sidebarStore = PanelSetup.getIt<SidebarStore>();
  late final _authStore = AdminSetup.getIt<AuthStore>();
  late final _countsStore = PanelSetup.getIt<PanelCountsStore>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _menuButtonFocus = FocusNode();
  bool _isDrawerOpen = false;
  bool _navigatedFromDrawer = false;

  List<ReactionDisposer> _reactions = [];

  @override
  void initState() {
    super.initState();

    _selectFromRoute();
    _authStore.currentUser();
    _loadCounts(_authStore.user);

    _reactions = [
      reaction(
        (_) => _authStore.user,
        (UserModel? user) {
          if (user == null) {
            GoRouter.of(context).go(AppRoutes.admin);
            return;
          }
          _loadCounts(user);
        },
      ),
      reaction(
        (_) => _authStore.state,
        (AuthState state) {
          if (state.logoutState is LogoutStateSuccess) {
            GoRouter.of(context).go(AppRoutes.admin);
          }

          if (state.logoutState is LogoutStateError) {
            final loginState = state.loginState as LoginStateError;
            Messenger.showError(context, loginState.failure.message);
          }
        },
      ),
    ];
  }

  @override
  void didUpdateWidget(covariant PanelPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tab != widget.tab || oldWidget.postType != widget.postType) _selectFromRoute();
  }

  void _selectFromRoute() {
    _sidebarStore.selectItem(widget.tab);
    if (widget.postType != null) _sidebarStore.selectPostType(widget.postType!);
  }

  void _loadCounts(UserModel? user) {
    if (user == null) return;
    _countsStore.load(includeUsers: user.permissions.canAccessUsersSection);
  }

  void _toggleDrawer() {
    final scaffold = _scaffoldKey.currentState;
    if (scaffold == null) return;
    scaffold.isDrawerOpen ? scaffold.closeDrawer() : scaffold.openDrawer();
  }

  void _onNavigateFromDrawer() {
    _navigatedFromDrawer = true;
    _scaffoldKey.currentState?.closeDrawer();
  }

  // Fechar sem escolher devolve o foco ao botão de menu; escolhendo, ele vai ao título da seção.
  void _onDrawerChanged(bool isOpen) {
    setState(() => _isDrawerOpen = isOpen);
    if (isOpen) return;
    if (!_navigatedFromDrawer) _menuButtonFocus.requestFocus();
    _navigatedFromDrawer = false;
  }

  @override
  void dispose() {
    _menuButtonFocus.dispose();
    for (var reaction in _reactions) {
      reaction.reaction.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);
    final isDesktop = breakpoint == Breakpoint.desktop;
    final screenWidth = MediaQuery.sizeOf(context).width;

    final content = Container(
      color: colors.surface,
      padding: EdgeInsets.only(
        top: components.panelMainPaddingTop(breakpoint),
        left: components.panelMainPaddingH(breakpoint),
        right: components.panelMainPaddingH(breakpoint),
      ),
      child: Observer(builder: (_) => _buildBody(_sidebarStore.selectedItem)),
    );

    return Material(
      color: colors.page,
      child: Column(
        children: [
          Observer(
            builder: (_) => PanelTopBar(
              user: _authStore.user,
              isMenuOpen: _isDrawerOpen,
              onMenuPressed: _toggleDrawer,
              menuFocusNode: _menuButtonFocus,
            ),
          ),
          Expanded(
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: colors.surface,
              drawerScrimColor:
                  colors.footerBackground.withValues(alpha: components.panelDrawerScrimOpacity),
              onDrawerChanged: _onDrawerChanged,
              drawer: isDesktop
                  ? null
                  : Drawer(
                      width: min(
                        components.panelDrawerMaxWidth,
                        screenWidth * components.panelDrawerWidthFactor,
                      ),
                      backgroundColor: colors.page,
                      shape: const RoundedRectangleBorder(),
                      child: Sidebar(isDrawer: true, onNavigate: _onNavigateFromDrawer),
                    ),
              body: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: components.panelSidebarWidth,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: colors.line,
                                width: AppTheme.dimensions.stroke.small,
                              ),
                            ),
                          ),
                          child: const Sidebar(),
                        ),
                        Expanded(child: content),
                      ],
                    )
                  : content,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(SidebarItem tab) {
    switch (tab) {
      case SidebarItem.users:
        return const UsersSection();
      case SidebarItem.media:
        return const MediaSection();
      case SidebarItem.categories:
        return const CategoriesSection();
      case SidebarItem.posts:
        return const PostsSection();
      case SidebarItem.team:
        return const TeamSection();
      case SidebarItem.library:
        return const LibrarySection();
    }
  }
}
