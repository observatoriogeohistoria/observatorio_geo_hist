import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/navbutton.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class NavbarMenu extends StatelessWidget {
  const NavbarMenu({
    required this.title,
    required this.menuChildren,
    super.key,
  });

  final String title;
  final List<NavButton> menuChildren;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.darkGray.withValues(alpha: 0.5),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.0, -0.5),
              radius: 1.5,
              colors: [
                Color(0xffffa726),
                Color.fromARGB(255, 249, 118, 24),
                Color(0xfffff3e0),
              ],
              stops: [0.3, 0.7, 1.0],
            ),
            // image: DecorationImage(
            //   fit: BoxFit.cover,
            //   image: AssetImage(
            //     '${AppAssets.images}/orange-gradient.jpg',
            //   ),
            // ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(AppTheme.dimensions.space.large),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: AppTitle.big(
                        text: title,
                        textAlign: TextAlign.center,
                        color: AppTheme.colors.lightGray,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close,
                          color: AppTheme.colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var item in menuChildren)
                      NavButton(
                        text: item.text.toUpperCase(),
                        onPressed: item.onPressed,
                        menuChildren: item.menuChildren,
                        textStyle: AppTheme(context).typography.headline.big,
                        textColor: AppTheme.colors.white,
                        textColorOnHover: AppTheme.colors.darkGray,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
