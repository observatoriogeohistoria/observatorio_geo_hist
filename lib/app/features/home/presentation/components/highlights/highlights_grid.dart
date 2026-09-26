import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Disposição dos destaques conforme a quantidade (1 a 3) e a faixa de largura
/// (spec 005). O item 0 é o principal.
///
/// - Celular: uma coluna, principal primeiro, com alturas fixas.
/// - Tablet e desktop: 1 item na largura toda; 2 itens em duas colunas
///   (1,6 : 1); 3 itens com o principal à esquerda e dois empilhados à direita.
///
/// Recebe um construtor de item para servir também ao esqueleto.
class HighlightsGrid extends StatelessWidget {
  const HighlightsGrid({super.key, required this.itemCount, required this.itemBuilder});

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    assert(itemCount >= 1 && itemCount <= 3, 'A grade de destaques mostra de 1 a 3 itens.');

    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);
    final gap = components.featuredGap;

    if (breakpoint == Breakpoint.mobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < itemCount; index++) ...[
            if (index > 0) SizedBox(height: gap),
            SizedBox(
              height: index == 0 ? components.featuredMainHeightMobile : components.featuredSmallHeightMobile,
              child: itemBuilder(context, index),
            ),
          ],
        ],
      );
    }

    final main = itemBuilder(context, 0);

    return SizedBox(
      height: components.featuredGridHeight(breakpoint),
      child: itemCount == 1
          ? main
          : Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: components.featuredMainFlex, child: main),
                SizedBox(width: gap),
                Expanded(
                  flex: components.featuredSideFlex,
                  child: itemCount == 2
                      ? itemBuilder(context, 1)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(child: itemBuilder(context, 1)),
                            SizedBox(height: gap),
                            Expanded(child: itemBuilder(context, 2)),
                          ],
                        ),
                ),
              ],
            ),
    );
  }
}
