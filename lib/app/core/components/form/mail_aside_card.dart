import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class MailAsideCard extends StatelessWidget {
  const MailAsideCard({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final breakpoint = ScreenUtils.breakpointOf(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(components.contactInfoPadding(breakpoint)),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            header: true,
            headingLevel: 2,
            child: Text(title, style: styles.stateTitle.copyWith(color: colors.ink)),
          ),
          SizedBox(height: components.contactInfoListTop),
          for (final (index, child) in children.indexed) ...[
            if (index > 0) SizedBox(height: components.contactInfoItemGap),
            child,
          ],
        ],
      ),
    );
  }
}

class MailAsideItem extends StatelessWidget {
  const MailAsideItem({super.key, required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTheme.typography.of(context).label.copyWith(
                color: AppTheme.colors.inkSecondary,
              ),
        ),
        SizedBox(height: AppTheme.dimensions.components.contactInfoLabelGap),
        ...children,
      ],
    );
  }
}
