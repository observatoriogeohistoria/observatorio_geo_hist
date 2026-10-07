import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/admin/admin_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_state.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/categories_section.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/library_section.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/media_section.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/posts_section.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/team_section.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/users_section.dart';
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

  List<ReactionDisposer> _reactions = [];

  @override
  void initState() {
    super.initState();

    _sidebarStore.selectItem(widget.tab);
    if (widget.postType != null) _sidebarStore.selectPostType(widget.postType!);

    _authStore.currentUser();

    _reactions = [
      reaction(
        (_) => _authStore.user,
        (UserModel? user) {
          if (user == null) {
            GoRouter.of(context).go(AppRoutes.admin);
          }
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
  void dispose() {
    for (var reaction in _reactions) {
      reaction.reaction.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final components = AppTheme.dimensions.components;
    final isDesktop = ScreenUtils.isDesktop(context);
    final contentPadding = components.panelContentPadding(ScreenUtils.breakpointOf(context));

    return Scaffold(
      backgroundColor: colors.page,
      drawer: isDesktop ? null : const Sidebar(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: colors.white),
        backgroundColor: colors.accent,
        title: Text(
          'PAINEL ADMINISTRATIVO',
          style: AppTheme.typography.of(context).h3.copyWith(color: colors.white),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.s8),
            child: AppIconButton(
              tooltip: 'Sair',
              icon: Icons.exit_to_app,
              color: colors.white,
              focusRingColor: colors.white,
              size: components.panelTopBarIcon,
              onPressed: _authStore.logout,
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Observer(
        builder: (context) {
          Widget body = Padding(
            padding: EdgeInsets.only(
              top: contentPadding,
              right: spacing.s8,
              left: contentPadding,
            ),
            child: _buildBody(_sidebarStore.selectedItem),
          );

          if (!isDesktop) return body;

          return Row(
            children: [
              const Sidebar(),
              Expanded(
                flex: 3,
                child: body,
              ),
            ],
          );
        },
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
