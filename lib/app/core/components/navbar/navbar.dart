import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/app_setup.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/navbutton.dart';
import 'package:observatorio_geo_hist/app/core/models/navbutton_item.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/stores/fetch_categories_store.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  late final FetchCategoriesStore store = AppSetup.getIt.get<FetchCategoriesStore>();

  @override
  void initState() {
    super.initState();

    store.fetchHistoryCategories();
    store.fetchGeographyCategories();
  }

  List<NavButtonItem> getNavButtonItens() {
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
        title: 'HISTÓRIA',
        options: store.historyCategories
            .map(
              (category) => NavButtonItem(
                title: category.title,
                category: category,
              ),
            )
            .toList(),
      ),
      NavButtonItem(
        title: 'GEOGRAFIA',
        options: store.geographyCategories
            .map(
              (category) => NavButtonItem(
                title: category.title,
                category: category,
              ),
            )
            .toList(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.8;

    return Container(
      color: AppTheme(context).colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  '${AppAssets.images}/logo.png',
                  width: width * 0.3,
                ),
                Observer(
                  builder: (context) {
                    return Row(
                      children: getNavButtonItens().map(
                        (option) {
                          final noOptions = (option.options?.isEmpty ?? true);

                          return NavButton(
                            text: option.title,
                            onPressed: () {
                              if (!noOptions) return;
                              GoRouter.of(context).replace(option.route!);
                            },
                            menuChildren: noOptions
                                ? null
                                : option.options!.map(
                                    (suboption) {
                                      return NavButton(
                                        text: suboption.title,
                                        onPressed: () {
                                          GoRouter.of(context).go(
                                            '/posts/${suboption.category!.area.key}/${suboption.category!.key}',
                                            extra: suboption.category,
                                          );
                                        },
                                        menuChildren: const [],
                                      );
                                    },
                                  ).toList(),
                          );
                        },
                      ).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
