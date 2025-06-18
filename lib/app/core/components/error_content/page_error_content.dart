import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PageErrorContent extends StatelessWidget {
  const PageErrorContent({
    required this.isSliver,
    super.key,
  });

  final bool isSliver;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.dimensions.space.huge.horizontalSpacing,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            size: 100.scale,
            color: AppTheme.colors.lighterGray,
          ),
          SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
          AppHeadline.big(
            text: 'Erro ao carregar a página',
            color: AppTheme.colors.gray,
          ),
        ],
      ),
    );

    return isSliver
        ? SliverFillRemaining(
            hasScrollBody: false,
            child: content,
          )
        : content;
  }
}
