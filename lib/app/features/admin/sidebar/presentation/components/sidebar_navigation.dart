import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
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
    double widthWhenCollapsed = 32.0.scale + 2 * AppTheme.dimensions.space.medium.scale;
    bool isMobile = DeviceUtils.isMobile(context);

    return Observer(
      builder: (context) {
        bool isCollapsed = sidebarStore.isCollapsed;

        return Drawer(
          width: isMobile
              ? MediaQuery.of(context).size.width
              : isCollapsed
                  ? widthWhenCollapsed
                  : null,
          child: Container(
            color: AppTheme.colors.white,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SidebarHeader(isCollapsed: isCollapsed),
                      SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
                      _buildItems(
                        items: sidebarItems,
                        selectedItem: sidebarStore.selectedItem,
                        selectedPostType: sidebarStore.selectedPostType,
                        showPostsSubItems: sidebarStore.showPostsSubItems,
                        isCollapsed: isCollapsed,
                        isMobile: isMobile,
                      ),
                      SizedBox(height: 64.verticalSpacing),
                    ],
                  ),
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

  Widget _buildItems({
    required List<SidebarItem> items,
    required SidebarItem selectedItem,
    required PostType? selectedPostType,
    bool showPostsSubItems = false,
    bool isCollapsed = false,
    bool isMobile = false,
  }) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.dimensions.space.medium.horizontalSpacing,
      ),
      shrinkWrap: true,
      itemCount: items.length,
      separatorBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(
          vertical:
              (isCollapsed ? AppTheme.dimensions.space.medium : AppTheme.dimensions.space.mini)
                  .verticalSpacing,
        ),
        child: Divider(color: AppTheme.colors.gray),
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        bool isPosts = item == SidebarItem.posts;

        return SidebarMenuItem(
          item: item,
          subItems: item.subItems,
          onItemClicked: () {
            if (isPosts) {
              if (isCollapsed) sidebarStore.toggleCollapse();
              if (selectedPostType == null) sidebarStore.selectPostType(PostType.article);

              sidebarStore.toggleShowPostsSubItems();
              sidebarStore.selectItem(item);

              final postType = (sidebarStore.selectedPostType ?? PostType.article).value;
              GoRouter.of(context).go('/admin/painel/posts?postType=$postType');

              return;
            }

            sidebarStore.selectItem(item);
            GoRouter.of(context).go('/admin/painel/${item.value}');
            if (isMobile) GoRouter.of(context).pop();
          },
          onSubItemClicked: (item) {
            if (!isPosts) return;

            sidebarStore.selectPostType(item);
            GoRouter.of(context).go('/admin/painel/posts?postType=${item.value}');

            if (isMobile) GoRouter.of(context).pop();
          },
          selectedItem: selectedItem,
          selectedSubItem: selectedPostType,
          showPostsSubItems: showPostsSubItems,
          isCollapsed: isCollapsed,
        );
      },
    );
  }
}
