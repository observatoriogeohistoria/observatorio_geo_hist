import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/navbutton.dart';
import 'package:observatorio_geo_hist/app/core/models/navbutton_item.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';

class GeoensineNavbar extends StatefulWidget {
  const GeoensineNavbar({super.key});

  @override
  State<GeoensineNavbar> createState() => _GeoensineNavbarState();
}

class _GeoensineNavbarState extends State<GeoensineNavbar> {
  List<NavButtonItem> navButtonItens = [
    const NavButtonItem(
      title: 'INÍCIO',
      route: AppRoutes.geoensine,
    ),
    const NavButtonItem(
      title: 'O PROJETO',
      route: AppRoutes.geoensineProjeto,
    ),
    const NavButtonItem(
      title: 'FORMAÇÃO',
      route: AppRoutes.geoensineProjeto,
    ),
    const NavButtonItem(
      title: 'COLABORE',
      route: AppRoutes.geoensineProjeto,
    ),
    const NavButtonItem(
      title: 'FALE CONOSCO',
      route: AppRoutes.geoensineProjeto,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: DeviceUtils.getPageHorizontalPadding(context),
      ),
      child: Row(
        children: [
          Image.asset(
            '${AppAssets.images}/logo_geoensine.png',
            width: 400.horizontalSpacing,
          ),
          Row(
            children: [
              for (var item in navButtonItens)
                NavButton(
                  text: item.title,
                  onPressed: () {},
                  menuChildren: const [],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
