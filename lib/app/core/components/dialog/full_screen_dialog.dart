import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class FullScreenDialog extends StatelessWidget {
  const FullScreenDialog({
    required this.child,
    this.title,
    super.key,
  });

  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.darkGray.withValues(alpha: 0.5),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(AppTheme.dimensions.space.large.scale),
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              radius: 1.5,
              colors: [Color(0xFFF5A123), Color(0xFFE67525)],
              stops: [0.3, 1.0],
            ),
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (title != null)
                    AppTitle.big(
                      text: title!,
                      textAlign: TextAlign.center,
                      color: AppTheme.colors.lightGray,
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: AppIconButton(
                      icon: Icons.close,
                      color: AppTheme.colors.white,
                      size: 32,
                      onPressed: () => GoRouter.of(context).pop(),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
