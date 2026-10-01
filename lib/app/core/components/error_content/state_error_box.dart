import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Caixa de erro de carregamento (`.state-box.err-state` do protótipo):
/// ícone, "Não foi possível carregar", texto de apoio e "Tentar de novo".
class StateErrorBox extends StatelessWidget {
  const StateErrorBox({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r18),
        border: Border.all(color: colors.line, width: AppTheme.dimensions.stroke.small),
      ),
      padding: EdgeInsets.symmetric(
        vertical: components.stateBoxPaddingVertical,
        horizontal: components.stateBoxPaddingHorizontal,
      ),
      child: Column(
        children: [
          ExcludeSemantics(
            child: Container(
              width: components.stateBoxIcon,
              height: components.stateBoxIcon,
              decoration: BoxDecoration(color: colors.errorSurface, shape: BoxShape.circle),
              child: Icon(Icons.close, size: components.stateBoxIconGlyph, color: colors.error),
            ),
          ),
          SizedBox(height: components.stateBoxGap),
          Semantics(
            liveRegion: true,
            child: Text(
              'Não foi possível carregar',
              textAlign: TextAlign.center,
              style: styles.stateTitle.copyWith(color: colors.ink),
            ),
          ),
          SizedBox(height: components.stateBoxGap),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: components.stateBoxTextMaxWidth),
            child: Text(
              'Verifique sua conexão e tente novamente.',
              textAlign: TextAlign.center,
              style: styles.regular.copyWith(color: colors.inkSecondary),
            ),
          ),
          SizedBox(height: components.stateBoxGap + components.stateBoxButtonGap),
          PrimaryButton.small(text: 'Tentar de novo', onPressed: onRetry),
        ],
      ),
    );
  }
}
