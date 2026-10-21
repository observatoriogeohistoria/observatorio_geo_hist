import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostEditorLayout extends StatelessWidget {
  const PostEditorLayout({
    required this.main,
    required this.side,
    required this.controller,
    super.key,
  });

  final List<Widget> main;
  final List<Widget> side;
  final ScrollController controller;

  Widget _column(List<Widget> children) {
    final gap = AppTheme.dimensions.components.editorCardsGap;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (index, child) in children.indexed) ...[
          if (index > 0) SizedBox(height: gap),
          child,
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);
    // Na ordem dos widgets: a ordem de leitura pula o "×" ao lado de cada autor.
    final mainColumn = FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: _column(main),
    );
    final sideColumn = FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: _column(side),
    );

    final content = breakpoint == Breakpoint.desktop
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: mainColumn),
              SizedBox(width: components.editorColumnsGap),
              SizedBox(width: components.editorSideWidth, child: sideColumn),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              mainColumn,
              SizedBox(height: components.editorCardsGap),
              sideColumn,
            ],
          );

    return Scrollbar(
      controller: controller,
      child: SingleChildScrollView(
        controller: controller,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: components.editorMaxWidth),
            child: Padding(
              padding: EdgeInsets.all(components.editorPadding(breakpoint)),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
