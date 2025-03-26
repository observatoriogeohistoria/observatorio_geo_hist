import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:observatorio_geo_hist/app/app_setup.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/navbar_mobile_menu.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar_menu.dart';
import 'package:observatorio_geo_hist/app/core/models/navbutton_item.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/stores/fetch_categories_store.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/transitions/transitions_builder.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  late final FetchCategoriesStore fetchCategoriesStore = AppSetup.getIt.get<FetchCategoriesStore>();

  bool get isMobile => DeviceUtils.isMobile(context);
  bool get isTablet => DeviceUtils.isTablet(context);
  bool get isDesktop => DeviceUtils.isDesktop(context);

  @override
  void initState() {
    super.initState();

    fetchCategoriesStore.fetchHistoryCategories();
    fetchCategoriesStore.fetchGeographyCategories();
  }

  List<NavButtonItem> get navButtonItens {
    return [
      const NavButtonItem(
        title: 'SOBRE',
        route: AppRoutes.root,
      ),
      const NavButtonItem(
        title: 'EXPOGEO',
        route: AppRoutes.root,
      ),
      NavButtonItem(
        title: PostsAreas.history.name.toUpperCase(),
        options: fetchCategoriesStore.historyCategories
            .map(
              (category) => NavButtonItem(
                title: category.title,
                category: category,
              ),
            )
            .toList(),
        area: PostsAreas.history,
      ),
      NavButtonItem(
        title: PostsAreas.geography.name.toUpperCase(),
        options: fetchCategoriesStore.geographyCategories
            .map(
              (category) => NavButtonItem(
                title: category.title,
                category: category,
              ),
            )
            .toList(),
        area: PostsAreas.geography,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.8;

    return Container(
      color: AppTheme.colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: (isDesktop
                ? (2 * AppTheme.dimensions.space.gigantic)
                : (isTablet ? AppTheme.dimensions.space.gigantic : AppTheme.dimensions.space.large))
            .horizontalSpacing,
      ),
      height: isMobile ? MediaQuery.of(context).size.height * 0.075 : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            '${AppAssets.images}/logo.png',
            width: isMobile ? null : width * 0.3,
            height: isMobile ? double.infinity : null,
          ),
          Observer(
            builder: (context) {
              if (isMobile) {
                return AppIconButton(
                  icon: Icons.menu,
                  color: AppTheme.colors.orange,
                  size: 32,
                  onPressed: () => _showMobileMenu(context),
                );
              }

              return Row(
                children: buildNavbarMenu(
                  context,
                  navButtonItens,
                  fetchCategoriesStore.selectedCategory,
                  fetchCategoriesStore.setSelectedCategory,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Mobile Menu',
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: TransitionsBuilder.slide,
      pageBuilder: (context, animation, secondaryAnimation) {
        return NavbarMobileMenu(
          navButtonItens: navButtonItens,
          onCategorySelected: fetchCategoriesStore.setSelectedCategory,
        );
      },
    );
  }
}
