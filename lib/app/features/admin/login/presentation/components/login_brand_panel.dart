import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/logo/app_logo.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/components/login_rings_painter.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LoginBrandPanel extends StatelessWidget {
  const LoginBrandPanel({super.key, this.compact = false});

  /// No celular a marca vira uma faixa: só logo, sobretítulo e título.
  final bool compact;

  static const _title = 'Publique no Observatório.';

  double _contentWidth(BuildContext context, Breakpoint breakpoint) {
    final components = AppTheme.dimensions.components;
    final width = MediaQuery.sizeOf(context).width;
    final column = compact
        ? width
        : width *
            components.loginBrandFlex /
            (components.loginBrandFlex + components.loginFormFlex);
    return column - 2 * components.loginBrandPaddingH(breakpoint);
  }

  // A coluna fica estreita perto de 600 px e "Observatório." quebraria no meio. A largura sai
  // da tela porque a página mede a altura das colunas, e LayoutBuilder não informa altura intrínseca.
  TextStyle _fitLongestWord(BuildContext context, TextStyle style, double maxWidth) {
    final painter = TextPainter(
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    );
    var widest = 0.0;
    for (final word in _title.split(' ')) {
      painter
        ..text = TextSpan(text: word, style: style)
        ..layout();
      widest = math.max(widest, painter.width);
    }
    painter.dispose();
    if (widest <= maxWidth) return style;

    final factor = maxWidth / widest;
    return style.copyWith(
      fontSize: (style.fontSize! * factor).floorToDouble(),
      letterSpacing: style.letterSpacing == null ? null : style.letterSpacing! * factor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final breakpoint = ScreenUtils.breakpointOf(context);
    final gap = components.loginBrandGap(breakpoint);
    final titleStyle = _fitLongestWord(
      context,
      styles.loginBrandTitle.copyWith(color: colors.white),
      _contentWidth(context, breakpoint),
    );

    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Painel da equipe'.toUpperCase(),
          style: styles.label.copyWith(color: colors.footerHighlight),
        ),
        SizedBox(height: components.loginEyebrowGap),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: titleStyle.fontSize! * components.loginBrandTitleMaxWidthEm,
          ),
          child: Semantics(
            header: true,
            child: Text(_title, style: titleStyle),
          ),
        ),
        if (!compact) ...[
          SizedBox(height: components.loginBrandLeadGap),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: components.loginBrandLeadMaxWidth),
            child: Text(
              'Publicações, biblioteca, equipe e imagens do site em um só lugar.',
              style: styles.regular.copyWith(color: colors.footerText),
            ),
          ),
        ],
      ],
    );

    return ColoredBox(
      color: colors.footerBackground,
      child: Stack(
        children: [
          Positioned.fill(
            child: ExcludeSemantics(
              child: IgnorePointer(
                child: ClipRect(
                  child: CustomPaint(
                    painter: LoginRingsPainter(
                      color: colors.footerHighlight.withValues(alpha: components.loginRingsOpacity),
                      step: components.loginRingsStep,
                      stroke: components.loginRingsStroke,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: components.loginBrandPaddingH(breakpoint),
              vertical: components.loginBrandPaddingV(breakpoint),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
              children: [
                // Perto de 600 px a coluna fica mais estreita que o logo com o subtítulo.
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: AppLogo(onDark: true, semanticLabel: 'Observatório, voltar ao site'),
                ),
                SizedBox(height: gap),
                heading,
                if (!compact) ...[
                  SizedBox(height: gap),
                  Text(
                    'Sem acesso? Peça a quem administra o painel para criar seu usuário.',
                    style: styles.small.copyWith(color: colors.footerText),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
