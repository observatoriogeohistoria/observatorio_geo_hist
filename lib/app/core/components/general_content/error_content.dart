import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
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
      child: AppBody.big(
        text: 'Erro ao carregar a página',
        color: AppTheme.colors.gray,
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
