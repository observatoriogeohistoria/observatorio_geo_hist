import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_label.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
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
        AppLabel.medium(
          text: text,
          color: AppTheme.colors.darkGray,
        ),
        SizedBox(height: AppTheme.dimensions.space.mini.verticalSpacing),
      ],
    );
  }
}
