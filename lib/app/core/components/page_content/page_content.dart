import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';

class PageContent extends StatelessWidget {
  const PageContent({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final margin = ScreenUtils.contentMargin(ScreenUtils.breakpointOf(context));

    return Align(
      alignment: Alignment.topCenter,
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ScreenUtils.contentMaxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: margin),
          child: child,
        ),
      ),
    );
  }
}
