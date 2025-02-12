import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/components/sidebar_header.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/components/sidebar_menu_item.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/components/toggle_collpase_button.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/models/sidebar_item.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/stores/sidebar_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late final SidebarStore sidebarStore = PanelSetup.getIt<SidebarStore>();

  final widthWhenCollapsed = 24 + 2 * AppTheme.dimensions.space.medium;

  @override
  Widget build(BuildContext context) {
    final items = [
      const SidebarItem(title: 'Usuários', icon: Icons.people),
      const SidebarItem(title: 'Mídias', icon: Icons.perm_media),
      const SidebarItem(title: 'Posts', icon: Icons.post_add_outlined),
    ];

    return Observer(
      builder: (context) {
        final isCollapsed = sidebarStore.isCollapsed;

        return Drawer(
          width: isCollapsed ? widthWhenCollapsed : null,
          child: Container(
            color: AppTheme.colors.lightGray,
            child: Column(
              children: [
                SidebarHeader(isCollapsed: isCollapsed),
                SizedBox(height: AppTheme.dimensions.space.large),
                _buildItems(items: items, isCollapsed: isCollapsed),
                const Spacer(),
                ToggleCollpaseButton(
                  onTap: sidebarStore.toggleCollapse,
                  isCollapsed: isCollapsed,
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
    bool isCollapsed = false,
  }) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.medium),
      shrinkWrap: true,
      itemCount: items.length,
      separatorBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(vertical: AppTheme.dimensions.space.medium),
        child: Divider(color: AppTheme.colors.gray),
      ),
      itemBuilder: (context, index) {
        return SidebarMenuItem(
          item: items[index],
          onClicked: () {},
          isCollapsed: isCollapsed,
        );
      },
    );
  }
}
