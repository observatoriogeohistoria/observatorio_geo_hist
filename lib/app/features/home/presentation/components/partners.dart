import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/carousel_options/carousel_options.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/partners_images.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/common/title_widget.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class Partners extends StatelessWidget {
  const Partners({super.key});

  @override
  Widget build(BuildContext context) {
    const images = PartnersImages.values;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppTheme.dimensions.space.large,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.dimensions.space.large,
            ),
            child: TitleWidget(
              title: 'PARCEIROS',
              color: AppTheme.colors.orange,
            ),
          ),
          SizedBox(height: AppTheme.dimensions.space.large),
          CarouselSlider.builder(
            options: carouselOptions(12 / 2),
            itemCount: images.length,
            itemBuilder: (context, index, realIndex) {
              final partner = images[index];

              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Center(child: Image.asset(partner.path)),
              );
            },
          ),
        ],
      ),
    );
  }
}
