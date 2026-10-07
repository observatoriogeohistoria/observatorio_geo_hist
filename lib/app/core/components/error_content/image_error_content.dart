import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class ImageErrorContent extends StatelessWidget {
  const ImageErrorContent({this.compact = false, super.key});

  /// Em espaço pequeno a frase não cabe; fica só o ícone, com a frase no tooltip.
  final bool compact;

  static const _message = 'Erro ao carregar a imagem';

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.colors.inkSecondary;
    final icon = Icon(
      Icons.error,
      size: AppTheme.dimensions.components.imageErrorIcon,
      color: color,
    );

    if (compact) {
      return Center(
        child: Tooltip(
          message: _message,
          excludeFromSemantics: true,
          child: Semantics(label: _message, child: icon),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        SizedBox(width: AppTheme.dimensions.spacing.s8),
        Flexible(
          child: Text(
            _message,
            textAlign: TextAlign.center,
            style: AppTheme.typography.of(context).small.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
