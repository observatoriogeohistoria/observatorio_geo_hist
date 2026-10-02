import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class MemberPageLayout extends StatelessWidget {
  const MemberPageLayout({super.key, required this.portrait, required this.content});

  final Widget portrait;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final gap = components.memberPageGap(ScreenUtils.breakpointOf(context));

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < components.memberPageStackBreak) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: components.memberPortraitStackedMaxWidth),
                  child: portrait,
                ),
              ),
              SizedBox(height: gap),
              content,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: components.memberPortraitMaxWidth, child: portrait),
            SizedBox(width: gap),
            Expanded(child: content),
          ],
        );
      },
    );
  }
}
