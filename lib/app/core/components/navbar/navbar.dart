import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/navbutton.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
import 'package:observatorio_geo_hist/app/core/utils/models/navbutton_item.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.8;

    return Container(
      color: AppTheme.colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo
                Image.asset(
                  '${AppAssets.images}/logo.png',
                  width: width * 0.3,
                ),

                // Navbar Options
                Row(
                  children: [
                    NavButton(text: 'SOBRE', onPressed: () {}),
                    NavButton(text: 'EXPOGEO', onPressed: () {}),
                    NavButton(
                      text: 'HISTÓRIA',
                      onPressed: () {},
                      options: [
                        NavButtonItem(title: 'Opinião', route: AppRoutes.posts),
                      ],
                    ),
                    NavButton(
                      text: 'GEOGRAFIA',
                      onPressed: () {},
                      options: [
                        NavButtonItem(title: 'Opinião', route: AppRoutes.posts),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
