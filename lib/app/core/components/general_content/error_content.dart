import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class ErrorContent extends StatelessWidget {
  const ErrorContent({
    required this.isSliver,
    super.key,
  });

  final bool isSliver;

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: Text(
        'Erro ao carregar a página',
        style: AppTheme.typography.body.large.copyWith(color: AppTheme.colors.gray),
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
