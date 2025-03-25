import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class CircularLoading extends StatelessWidget {
  const CircularLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 32.scale,
        width: 32.scale,
        child: CircularProgressIndicator(
          color: AppTheme.colors.orange,
        ),
      ),
    );
  }
}
