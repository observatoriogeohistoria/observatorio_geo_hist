import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LinearLoading extends StatelessWidget {
  const LinearLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppTheme.dimensions.space.small.verticalSpacing,
        ),
        child: LinearProgressIndicator(
          color: AppTheme.colors.orange,
        ),
      ),
    );
  }
}
