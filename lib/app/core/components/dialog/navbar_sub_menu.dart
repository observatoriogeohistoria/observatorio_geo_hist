import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/navbutton.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/full_screen_dialog.dart';
import 'package:observatorio_geo_hist/app/core/components/scroll/no_scroll_configuration.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class NavbarSubMenu extends StatelessWidget {
  const NavbarSubMenu({
    required this.title,
    required this.menuChildren,
    super.key,
  });

  final String title;
  final List<NavButton> menuChildren;

  @override
  Widget build(BuildContext context) {
    return FullScreenDialog(
      title: title,
      child: Center(
        child: NoScrollConfiguration(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (var item in menuChildren)
                  NavButton(
                    text: item.text.toUpperCase(),
                    onPressed: item.onPressed,
                    menuChildren: item.menuChildren,
                    textStyle: AppTheme.typography.headline.big,
                    textColor: AppTheme.colors.white,
                    textColorOnHover: AppTheme.colors.darkGray,
                  ),
                SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
