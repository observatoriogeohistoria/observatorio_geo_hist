import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/partners_images.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/common/title_widget.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class Partners extends StatelessWidget {
  const Partners({super.key});

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(color: AppTheme.colors.lightGray);
    const images = PartnersImages.values;

    return Padding(
      padding: EdgeInsets.only(
        top: AppTheme.dimensions.space.large,
        bottom: AppTheme.dimensions.space.xlarge,
      ),
      child: Column(
        children: [
          TitleWidget(
            title: 'PARCEIROS',
            color: AppTheme.colors.orange,
          ),
          SizedBox(height: AppTheme.dimensions.space.large),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppTheme.dimensions.space.medium,
            runSpacing: AppTheme.dimensions.space.medium,
            children: [
              for (final partner in images)
                Container(
                  padding: EdgeInsets.all(AppTheme.dimensions.space.small),
                  decoration: BoxDecoration(
                    color: AppTheme.colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.large),
                    border: Border(
                      top: border,
                      left: border,
                      right: border,
                      bottom: border.copyWith(width: 4),
                    ),
                  ),
                  child: Image.asset(partner.path),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
