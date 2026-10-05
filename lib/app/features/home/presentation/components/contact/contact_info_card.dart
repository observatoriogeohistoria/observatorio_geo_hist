import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/inline_link.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_strings.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class ContactInfoCard extends StatelessWidget {
  const ContactInfoCard({super.key});

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
            child: Text('Outros meios', style: styles.stateTitle.copyWith(color: colors.ink)),
          ),
          SizedBox(height: components.contactInfoListTop),
          const _InfoItem(
            label: 'E-mail',
            children: [InlineLink(text: AppStrings.email, url: AppStrings.emailUrl)],
          ),
          SizedBox(height: components.contactInfoItemGap),
          const _InfoItem(
            label: 'Telefones',
            children: [
              InlineLink(
                text: AppStrings.phoneOne,
                url: AppStrings.phoneOneUrl,
                semanticLabel: 'Telefone ${AppStrings.phoneOne}',
              ),
              InlineLink(
                text: AppStrings.phoneTwo,
                url: AppStrings.phoneTwoUrl,
                semanticLabel: 'Telefone ${AppStrings.phoneTwo}',
              ),
            ],
          ),
          SizedBox(height: components.contactInfoItemGap),
          _InfoItem(
            label: 'Endereço',
            children: [
              Text(AppStrings.footerAddress, style: styles.regular.copyWith(color: colors.ink)),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.label, required this.children});

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
