import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/models/article_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    required this.body,
    required this.index,
    super.key,
  });

  final ArticleModel body;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final typography = AppTheme.typography.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$index', style: typography.label.copyWith(color: colors.inkSecondary)),
        SizedBox(height: components.panelCardTextGap),
        Text(body.title, style: typography.h3.copyWith(color: colors.ink)),
        SizedBox(height: components.panelCardTextGap),
        Text(
          body.subtitle,
          style: typography.regular.copyWith(color: colors.inkSecondary),
        ),
      ],
    );
  }
}
