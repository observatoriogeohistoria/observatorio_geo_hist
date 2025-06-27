import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
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
            size: 48.scale,
            color: AppTheme.colors.lighterGray,
          ),
          SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
          AppTitle.big(
            text: 'Hmmm, parece que não há nada por aqui',
            textAlign: TextAlign.center,
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
