import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/social_buttons.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/components/partners/partner_logo_grid.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class Support extends StatelessWidget {
  const Support({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;

    const follow = _SupportGroup(title: 'Acompanhe', child: SocialPills());
    final partners = _SupportGroup(
      title: 'Apoio',
      child: PartnerLogoGrid(minColumnWidth: components.partnerColumnMinWidthSmall),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.line)),
      ),
      child: PageContent(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: components.supportPaddingVertical),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < components.supportColumnsBreak) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [follow, SizedBox(height: components.supportColumnGapV), partners],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  follow,
                  SizedBox(width: components.supportColumnGapH),
                  Expanded(child: partners),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SupportGroup extends StatelessWidget {
  const _SupportGroup({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          header: true,
          child: Text(
            title.toUpperCase(),
            style: AppTheme.typography.of(context).label.copyWith(color: colors.inkSecondary),
          ),
        ),
        SizedBox(height: AppTheme.dimensions.components.supportLabelGap),
        child,
      ],
    );
  }
}
