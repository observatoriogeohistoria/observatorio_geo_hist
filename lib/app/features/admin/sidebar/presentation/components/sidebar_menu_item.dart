import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/enums/sidebar_item.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class SidebarMenuItem extends StatelessWidget {
  const SidebarMenuItem({
    required this.item,
    required this.onClicked,
    required this.isCollapsed,
    required this.isSelected,
    super.key,
  });

  final SidebarItem item;
  final VoidCallback onClicked;

  final bool isSelected;
  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    const iconSize = 24.0;
    final widthWhenCollapsed = 24 + 2 * AppTheme.dimensions.space.medium;

    final icon = Icon(item.icon, color: AppTheme.colors.orange, size: iconSize);

    return Tooltip(
      message: isCollapsed ? item.title : '',
      verticalOffset: -(iconSize / 2),
      margin: EdgeInsets.only(left: widthWhenCollapsed),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onClicked,
          mouseCursor: SystemMouseCursors.click,
          hoverColor: isCollapsed ? Colors.transparent : AppTheme.colors.lightGray,
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.medium),
          child: isCollapsed
              ? icon
              : Container(
                  padding: EdgeInsets.all(AppTheme.dimensions.space.medium),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.colors.lightGray : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.medium),
                  ),
                  child: Row(
                    children: [
                      icon,
                      SizedBox(width: AppTheme.dimensions.space.medium),
                      AppTitle.medium(
                        text: item.title,
                        color: AppTheme.colors.darkGray,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
