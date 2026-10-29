import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class RightAlignedDialog extends StatelessWidget {
  const RightAlignedDialog({
    required this.child,
    this.width,
    this.widthFollowsContent = false,
    super.key,
  });

  final Widget child;

  final double? width;
  final bool widthFollowsContent;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);
    final size = MediaQuery.sizeOf(context);
    final radius = Radius.circular(AppTheme.dimensions.radii.r12);

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: colors.page,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(left: radius),
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: widthFollowsContent
              ? null
              : (width ?? size.width * components.panelDialogWidthFactor(breakpoint)),
          height: size.height,
          padding: EdgeInsets.all(components.panelDialogPadding(breakpoint)),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: colors.line)),
          ),
          child: child,
        ),
      ),
    );
  }
}
