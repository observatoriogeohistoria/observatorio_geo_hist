import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class ReadingColumn extends StatelessWidget {
  const ReadingColumn({super.key, required this.children, this.paddingTop});

  final List<Widget> children;

  final double? paddingTop;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);

    return PageContent(
      child: Padding(
        padding: EdgeInsets.only(
          top: paddingTop ?? components.readingPaddingTop,
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
