import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/enums/sidebar_item.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class SidebarMenuItem extends StatelessWidget {
  const SidebarMenuItem({
    required this.item,
    required this.subItems,
    required this.onItemClicked,
    required this.onSubItemClicked,
    required this.selectedItem,
    required this.selectedSubItem,
    required this.showPostsSubItems,
    required this.isCollapsed,
    super.key,
  });

  final SidebarItem item;
  final List<PostType> subItems;

  final void Function() onItemClicked;
  final void Function(PostType item) onSubItemClicked;

  final SidebarItem selectedItem;
  final PostType? selectedSubItem;

  final bool showPostsSubItems;
  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    double iconSize = 32.scale;
    double widthWhenCollapsed = iconSize + 2 * AppTheme.dimensions.space.medium.scale;

    Widget icon = Icon(item.icon, color: AppTheme.colors.orange, size: iconSize);

    bool itemIsSelected = item == selectedItem;
    bool showSubItems = subItems.isNotEmpty && showPostsSubItems && itemIsSelected;

    bool subItemIsSelected(PostType subItem) => subItem == selectedSubItem;

    return Column(
      children: [
        Tooltip(
          message: isCollapsed ? item.title : '',
          verticalOffset: -(iconSize / 2),
          margin: EdgeInsets.only(left: widthWhenCollapsed),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onItemClicked,
              mouseCursor: SystemMouseCursors.click,
              hoverColor: isCollapsed ? Colors.transparent : AppTheme.colors.lightGray,
              borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.medium),
              child: isCollapsed
                  ? icon
                  : Container(
                      padding: EdgeInsets.all(AppTheme.dimensions.space.medium.scale),
                      decoration: BoxDecoration(
                        color: itemIsSelected ? AppTheme.colors.lightGray : Colors.transparent,
                        borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.medium),
                      ),
                      child: Row(
                        children: [
                          icon,
                          SizedBox(width: AppTheme.dimensions.space.medium.horizontalSpacing),
                          Expanded(
                            child: AppTitle.medium(
                              text: item.title,
                              color: AppTheme.colors.darkGray,
                              notSelectable: true,
                            ),
                          ),
                          if (subItems.isNotEmpty)
                            Icon(
                              showSubItems
                                  ? Icons.keyboard_arrow_up_outlined
                                  : Icons.keyboard_arrow_down_outlined,
                              color: AppTheme.colors.gray,
                              size: iconSize,
                            ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
        if (showSubItems) ...[
          SizedBox(height: AppTheme.dimensions.space.mini.verticalSpacing),
          for (var subItem in subItems)
            TextButton(
              onPressed: () => onSubItemClicked(subItem),
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith(
                  (states) {
                    return states.contains(WidgetState.hovered)
                        ? AppTheme.colors.orange
                        : AppTheme.colors.gray;
                  },
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppTheme.dimensions.space.small.scale),
                child: Text(
                  subItem.portuguesePlural,
                  style: AppTheme.typography.title.small.copyWith(
                    color:
                        subItemIsSelected(subItem) ? AppTheme.colors.orange : AppTheme.colors.gray,
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }
}
