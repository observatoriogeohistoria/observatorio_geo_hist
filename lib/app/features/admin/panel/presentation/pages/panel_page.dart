import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/features/admin/admin_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_state.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/users_section.dart';
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
          Messenger.showError(context, AuthFailure.toMessage(loginState.failure));
        }
      }),
    ];
  }

  @override
  void dispose() {
    for (var reaction in _reactions) {
      reaction();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = DeviceUtils.isDesktop(context);

    return Scaffold(
      drawer: isDesktop ? null : const Sidebar(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppTheme.colors.white),
        backgroundColor: AppTheme.colors.orange,
        title: AppHeadline.small(
          text: 'PAINEL ADMINISTRATIVO',
          color: AppTheme.colors.white,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.small),
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
          final body = _buildBody(sidebarStore.selectedItem);

          if (!isDesktop) return body;

          return Row(
            children: [
              const Flexible(child: Sidebar()),
              Expanded(child: body),
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
        return Container();
      case SidebarItem.posts:
        return Container();
    }
  }
}
