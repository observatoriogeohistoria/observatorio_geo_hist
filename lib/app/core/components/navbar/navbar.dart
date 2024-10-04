import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/navbutton.dart';
import 'package:observatorio_geo_hist/app/core/models/navbutton_item.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class Navbar extends StatelessWidget {
  const Navbar({
    required this.options,
    super.key,
  });

  final List<NavButtonItem> options;

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

                Row(
                  children: options.map((option) {
                    return NavButton(
                      text: option.title,
                      onPressed: () {
                        Navigator.pushNamed(context, option.route);
                      },
                      options: option.options,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
