import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class EmptyListMessage extends StatelessWidget {
  const EmptyListMessage({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppTheme.dimensions.spacing.s24),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTheme.typography.of(context).regular.copyWith(
                color: AppTheme.colors.inkSecondary,
              ),
        ),
      ),
    );
  }
}
