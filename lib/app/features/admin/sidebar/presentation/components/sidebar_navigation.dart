import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/components/sidebar_header.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/components/sidebar_menu_item.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/components/toggle_collpase_button.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/enums/sidebar_item.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/stores/sidebar_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late final AuthStore authStore = PanelSetup.getIt<AuthStore>();
  late final SidebarStore sidebarStore = PanelSetup.getIt<SidebarStore>();

  List<SidebarItem> sidebarItems = [];
  List<ReactionDisposer> _reactions = [];

  @override
  void initState() {
    super.initState();

    if (authStore.user != null) {
      _setSidebarItems(authStore.user);
    }

    _reactions = [
      reaction((_) => authStore.user, (UserModel? user) {
        _setSidebarItems(user);
      }),
    ];
  }

  void _setSidebarItems(UserModel? user) {
    setState(() {
      sidebarItems = [
        if (user?.permissions.canAccessUsersSection ?? false) SidebarItem.users,
        SidebarItem.media,
        SidebarItem.categories,
        SidebarItem.posts,
        SidebarItem.team,
        SidebarItem.library,
      ];
    });
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
    final spacing = AppTheme.dimensions.spacing;
    final components = AppTheme.dimensions.components;
    final widthWhenCollapsed = components.panelSidebarIcon + 2 * components.panelSidebarItemPadding;
    final isMobile = ScreenUtils.isMobile(context);

    return Observer(
      builder: (context) {
        bool isCollapsed = sidebarStore.isCollapsed;

        return Drawer(
          width: isMobile
              ? MediaQuery.of(context).size.width
              : isCollapsed
                  ? widthWhenCollapsed
                  : components.panelSidebarWidth,
          child: Container(
            color: AppTheme.colors.page,
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: SidebarHeader(isCollapsed: isCollapsed)),
                    SliverToBoxAdapter(child: SizedBox(height: spacing.s24)),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: components.panelSidebarItemPadding,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = sidebarItems[index];
                            final isPosts = item == SidebarItem.posts;

                            return Observer(
                              builder: (context) {
                                final selectedItem = sidebarStore.selectedItem;
                                final selectedPostType = sidebarStore.selectedPostType;
                                final showPostsSubItems = sidebarStore.showPostsSubItems;

                                return SidebarMenuItem(
                                  item: item,
                                  subItems: item.subItems,
                                  onItemClicked: () {
                                    if (isPosts) {
                                      if (isCollapsed) sidebarStore.toggleCollapse();
                                      if (sidebarStore.selectedPostType == null) {
                                        sidebarStore.selectPostType(PostType.article);
                                      }

                                      sidebarStore.toggleShowPostsSubItems();
                                      sidebarStore.selectItem(item);

                                      final postType =
                                          (sidebarStore.selectedPostType ?? PostType.article).value;
                                      GoRouter.of(context).go(AppRoutes.panelPosts(postType));

                                      return;
                                    }

                                    sidebarStore.selectItem(item);
                                    GoRouter.of(context).go(AppRoutes.panelTab(item.value));

                                    if (isMobile) GoRouter.of(context).pop();
                                  },
                                  onSubItemClicked: (subItem) {
                                    if (!isPosts) return;

                                    sidebarStore.selectPostType(subItem);
                                    GoRouter.of(context).go(AppRoutes.panelPosts(subItem.value));

                                    if (isMobile) GoRouter.of(context).pop();
                                  },
                                  selectedItem: selectedItem,
                                  selectedSubItem: selectedPostType,
                                  showPostsSubItems: showPostsSubItems,
                                  isCollapsed: isCollapsed,
                                );
                              },
                            );
                          },
                          childCount: sidebarItems.length,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: spacing.s64)),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ToggleCollpaseButton(
                        onTap: () {
                          if (isMobile) {
                            GoRouter.of(context).pop();
                            return;
                          }
                          sidebarStore.toggleCollapse();
                        },
                        isCollapsed: isCollapsed,
                        isMenu: isMobile,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
