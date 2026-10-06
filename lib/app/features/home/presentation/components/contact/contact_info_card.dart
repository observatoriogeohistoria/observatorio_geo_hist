import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/inline_link.dart';
import 'package:observatorio_geo_hist/app/core/components/form/mail_aside_card.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_strings.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class ContactInfoCard extends StatelessWidget {
  const ContactInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final styles = AppTheme.typography.of(context);

    return MailAsideCard(
      title: 'Outros meios',
      children: [
        const MailAsideItem(
          label: 'E-mail',
          children: [InlineLink(text: AppStrings.email, url: AppStrings.emailUrl)],
        ),
        const MailAsideItem(
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
        MailAsideItem(
          label: 'Endereço',
          children: [
            Text(AppStrings.footerAddress,
                style: styles.regular.copyWith(color: AppTheme.colors.ink)),
          ],
        ),
      ],
    );
  }
}
