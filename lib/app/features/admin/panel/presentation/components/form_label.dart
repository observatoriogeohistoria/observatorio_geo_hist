import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class FormLabel extends StatelessWidget {
  const FormLabel({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: AppTheme.typography.of(context).formLabel.copyWith(color: AppTheme.colors.ink),
        ),
        SizedBox(height: AppTheme.dimensions.spacing.s4),
      ],
    );
  }
}
