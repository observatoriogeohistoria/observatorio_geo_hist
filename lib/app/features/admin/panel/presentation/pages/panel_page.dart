import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/features/admin/admin_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_state.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/categories_section.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/media_section.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/posts_section.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/users_section.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/components/sidebar_navigation.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/enums/sidebar_item.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/stores/sidebar_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PanelPage extends StatefulWidget {
  const PanelPage({
    required this.tab,
    super.key,
  });

  final SidebarItem tab;

  @override
  State<PanelPage> createState() => _PanelPageState();
}

class _PanelPageState extends State<PanelPage> {
  late final SidebarStore sidebarStore = PanelSetup.getIt<SidebarStore>();
  late final AuthStore authStore = AdminSetup.getIt<AuthStore>();

  List<ReactionDisposer> _reactions = [];

  @override
  void initState() {
    super.initState();

    sidebarStore.selectItem(widget.tab);
    authStore.currentUser();

    _reactions = [
      reaction((_) => authStore.state, (AuthState state) {
        if (state.user == null) {
          GoRouter.of(context).go('/admin');
        }

        if (state.logoutState is LogoutStateSuccess) {
          GoRouter.of(context).go('/admin');
        }

        if (state.logoutState is LogoutStateError) {
          final loginState = state.loginState as LoginStateError;
          Messenger.showError(context, loginState.failure.message);
        }
      }),
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
    bool isDesktop = DeviceUtils.isDesktop(context);

    return Scaffold(
      drawer: isDesktop ? null : const Sidebar(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppTheme(context).colors.white),
        backgroundColor: AppTheme(context).colors.orange,
        title: AppHeadline.small(
          text: 'PAINEL ADMINISTRATIVO',
          color: AppTheme(context).colors.white,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppTheme(context).dimensions.space.small),
            child: IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: authStore.logout,
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Observer(
        builder: (context) {
          Widget body = _buildBody(sidebarStore.selectedItem);

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
    }
  }
}
