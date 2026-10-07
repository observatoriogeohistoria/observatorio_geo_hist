import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
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
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final components = AppTheme.dimensions.components;
    final typography = AppTheme.typography.of(context);
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r8);

    final iconSize = components.panelSidebarIcon;
    final widthWhenCollapsed = iconSize + 2 * components.panelSidebarItemPadding;

    final itemIsSelected = item == selectedItem;
    final showSubItems = subItems.isNotEmpty && showPostsSubItems && itemIsSelected;

    final icon = Icon(item.icon, color: colors.accent, size: iconSize);

    bool subItemIsSelected(PostType subItem) => subItem == selectedSubItem;

    return Column(
      children: [
        Tooltip(
          message: isCollapsed ? item.title : '',
          verticalOffset: -(iconSize / 2),
          margin: EdgeInsets.only(left: widthWhenCollapsed),
          child: Semantics(
            button: true,
            selected: itemIsSelected,
            expanded: subItems.isNotEmpty ? showSubItems : null,
            label: item.title,
            excludeSemantics: true,
            child: AppFocusRing(
              borderRadius: radius,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: onItemClicked,
                  mouseCursor: SystemMouseCursors.click,
                  hoverColor: isCollapsed ? Colors.transparent : colors.surface,
                  borderRadius: radius,
                  child: isCollapsed
                      ? icon
                      : Container(
                          padding: EdgeInsets.all(components.panelSidebarItemPadding),
                          decoration: BoxDecoration(
                            color: itemIsSelected ? colors.accentSoft : Colors.transparent,
                            borderRadius: radius,
                          ),
                          child: Row(
                            children: [
                              icon,
                              SizedBox(width: spacing.s16),
                              Expanded(
                                child: Text(
                                  item.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: typography.h3.copyWith(color: colors.ink),
                                ),
                              ),
                              if (subItems.isNotEmpty)
                                Icon(
                                  showSubItems
                                      ? Icons.keyboard_arrow_up_outlined
                                      : Icons.keyboard_arrow_down_outlined,
                                  color: colors.inkSecondary,
                                  size: iconSize,
                                ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: isCollapsed ? spacing.s24 : spacing.s8),
        if (showSubItems) ...[
          SizedBox(height: spacing.s4),
          for (var subItem in subItems)
            AppFocusRing(
              borderRadius: radius,
              child: TextButton(
                onPressed: () => onSubItemClicked(subItem),
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: radius)),
                  overlayColor: WidgetStatePropertyAll(colors.surface),
                  foregroundColor: WidgetStateProperty.resolveWith(
                    (states) {
                      return states.contains(WidgetState.hovered) || subItemIsSelected(subItem)
                          ? colors.accent
                          : colors.inkSecondary;
                    },
                  ),
                  textStyle: WidgetStatePropertyAll(typography.regular),
                ),
                child: Semantics(
                  selected: subItemIsSelected(subItem),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: spacing.s8),
                    child: Text(subItem.portuguesePlural),
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }
}
