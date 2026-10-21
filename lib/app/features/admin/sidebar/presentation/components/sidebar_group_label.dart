import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class SidebarGroupLabel extends StatelessWidget {
  const SidebarGroupLabel({required this.title, this.isFirst = false, super.key});

  final String title;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        components.panelNavItemPaddingH,
        isFirst ? components.panelGroupLabelPaddingTopFirst : components.panelGroupLabelPaddingTop,
        components.panelNavItemPaddingH,
        components.panelGroupLabelPaddingBottom,
      ),
      child: Semantics(
        header: true,
        child: Text(
          title.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTheme.typography
              .of(context)
              .panelGroupLabel
              .copyWith(color: AppTheme.colors.inkSecondary),
        ),
      ),
    );
  }
}
