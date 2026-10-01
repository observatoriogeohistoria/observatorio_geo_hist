import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Coluna de leitura (`.prose`): até 680 px, centralizada na largura do site,
/// com respiro acima e abaixo. Funciona com ou sem `PageHeader` acima.
class ReadingColumn extends StatelessWidget {
  const ReadingColumn({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);

    return PageContent(
      child: Padding(
        padding: EdgeInsets.only(
          top: components.readingPaddingTop,
          bottom: components.readingPaddingBottom(breakpoint),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: components.readingMaxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
