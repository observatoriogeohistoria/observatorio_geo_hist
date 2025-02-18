import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
  late final SidebarStore sidebarStore = PanelSetup.getIt<SidebarStore>();

  final widthWhenCollapsed = 24 + 2 * AppTheme.dimensions.space.medium;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final isCollapsed = sidebarStore.isCollapsed;

        return Drawer(
          width: isCollapsed ? widthWhenCollapsed : null,
          child: Container(
            color: AppTheme.colors.white,
            child: Column(
              children: [
                SidebarHeader(isCollapsed: isCollapsed),
                SizedBox(height: AppTheme.dimensions.space.large),
                _buildItems(
                  items: SidebarItem.values,
                  selectedItem: sidebarStore.selectedItem,
                  isCollapsed: isCollapsed,
                ),
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
    required SidebarItem? selectedItem,
    bool isCollapsed = false,
  }) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.medium),
      shrinkWrap: true,
      itemCount: items.length,
      separatorBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(
          vertical:
              isCollapsed ? AppTheme.dimensions.space.medium : AppTheme.dimensions.space.xsmall,
        ),
        child: Divider(color: AppTheme.colors.gray),
      ),
      itemBuilder: (context, index) {
        return SidebarMenuItem(
          item: items[index],
          onClicked: () {
            sidebarStore.selectItem(items[index]);
            Navigator.of(context).pop();
          },
          isSelected: items[index] == sidebarStore.selectedItem,
          isCollapsed: isCollapsed,
        );
      },
    );
  }
}
