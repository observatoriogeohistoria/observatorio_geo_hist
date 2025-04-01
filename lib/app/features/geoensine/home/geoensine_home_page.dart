import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
import 'package:observatorio_geo_hist/app/features/geoensine/home/components/geoensine_introduction.dart';
import 'package:observatorio_geo_hist/app/features/geoensine/home/components/geoensine_navbar.dart';
import 'package:observatorio_geo_hist/app/features/geoensine/home/components/geoensine_polifonia.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class GeoensineHomePage extends StatefulWidget {
  const GeoensineHomePage({super.key});

  @override
  State<GeoensineHomePage> createState() => _GeoensineHomePageState();
}

class _GeoensineHomePageState extends State<GeoensineHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Image.asset(
              '${AppAssets.geoensine}/home_geoensine.png',
              width: double.infinity,
            ),
          ),
          const SliverToBoxAdapter(child: GeoensineNavbar()),
          const SliverToBoxAdapter(child: GeoensineIntroduction()),
          const SliverToBoxAdapter(child: GeoensinePolifonia()),
        ],
      ),
    );
  }
}
