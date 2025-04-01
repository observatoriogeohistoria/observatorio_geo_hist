import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/navbutton.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/full_screen_dialog.dart';
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
      child: Scrollbar(
        thumbVisibility: false,
        trackVisibility: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
            ],
          ),
        ),
      ),
    );
  }
}
