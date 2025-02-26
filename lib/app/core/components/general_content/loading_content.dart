import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LoadingContent extends StatelessWidget {
  const LoadingContent({
    required this.isSliver,
    super.key,
  });

  final bool isSliver;

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: Center(
        child: CircularProgressIndicator(color: AppTheme(context).colors.orange),
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
