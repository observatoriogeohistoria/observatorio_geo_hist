import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/full_screen_dialog.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar_menu.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/navbutton_item.dart';

class NavbarMobileMenu extends StatelessWidget {
  const NavbarMobileMenu({
    required this.navButtonItens,
    required this.onCategorySelected,
    this.categorySelected,
    super.key,
  });

  final List<NavButtonItem> navButtonItens;
  final void Function(CategoryModel?) onCategorySelected;
  final CategoryModel? categorySelected;

  @override
  Widget build(BuildContext context) {
    return FullScreenDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: buildNavbarMenu(
          context,
          navButtonItens,
          categorySelected,
          onCategorySelected,
        ),
      ),
    );
  }
}
