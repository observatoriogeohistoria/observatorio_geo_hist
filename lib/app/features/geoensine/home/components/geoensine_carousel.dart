import 'dart:async';

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/custom_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/mouse_region/app_mouse_region.dart';
import 'package:observatorio_geo_hist/app/core/components/pages_circles/pages_circles.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class GeoensineCarousel extends StatefulWidget {
  const GeoensineCarousel({super.key});

  @override
  State<GeoensineCarousel> createState() => _GeoensineCarouselState();
}

class _GeoensineCarouselState extends State<GeoensineCarousel> {
  int currentIndex = 0;
  Timer? _timer;

  final List<String> images = [
    '${AppAssets.geoensine}/carousel_1.png',
    '${AppAssets.geoensine}/carousel_2.png',
    '${AppAssets.geoensine}/carousel_3.png',
    '${AppAssets.geoensine}/carousel_4.png',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer?.cancel(); // Garante que não há múltiplos timers rodando
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _nextIndex(auto: true);
    });
  }

  void _previousIndex() {
    _nextIndex(auto: false, decrement: true);
  }

  void _nextIndex({bool auto = false, bool decrement = false}) {
    setState(() {
      if (decrement) {
        currentIndex = (currentIndex - 1) % images.length;
        if (currentIndex < 0) currentIndex = images.length - 1;
      } else {
        currentIndex = (currentIndex + 1) % images.length;
      }
    });

    if (!auto) _startAutoSlide();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            AppMouseRegion(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Image.asset(
                  images[currentIndex],
                  key: ValueKey<String>(images[currentIndex]),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.dimensions.space.small.scale,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomIconButton(
                    icon: Icons.arrow_back_ios_outlined,
                    onTap: _previousIndex,
                  ),
                  SizedBox(width: AppTheme.dimensions.space.small.horizontalSpacing),
                  CustomIconButton(
                    icon: Icons.arrow_forward_ios_outlined,
                    onTap: _nextIndex,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
        PagesCircles(
          count: 4,
          currentPage: currentIndex,
        ),
      ],
    );
  }
}
