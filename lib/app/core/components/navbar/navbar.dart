import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/buttons/navbutton.dart';
import 'package:observatorio_geo_hist/app/core/utils/app_assets.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.8;

    return Row(
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
                    options: const [
                      'OPINIÃO',
                      'EXPERIÊNCIAS EDUCATIVAS',
                      'NARRATIVAS',
                      'EVENTOS',
                      'BIBLIOTECA',
                      'NOSSAS PESQUISAS',
                      'GEOENSINE',
                    ],
                  ),
                  NavButton(
                    text: 'GEOGRAFIA',
                    onPressed: () {},
                    options: const [
                      'OPINIÃO',
                      'EXPERIÊNCIAS EDUCATIVAS',
                      'NARRATIVAS',
                      'EVENTOS',
                      'BIBLIOTECA',
                      'NOSSAS PESQUISAS',
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
