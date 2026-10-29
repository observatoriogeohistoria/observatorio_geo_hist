import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/copy_button.dart';
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
          children: [
            CopyableInlineLink(text: AppStrings.email, url: AppStrings.emailUrl, subject: 'e-mail'),
          ],
        ),
        const MailAsideItem(
          label: 'Telefones',
          children: [
            CopyableInlineLink(
              text: AppStrings.phoneOne,
              url: AppStrings.phoneOneUrl,
              subject: 'telefone',
              semanticLabel: 'Telefone ${AppStrings.phoneOne}',
            ),
            CopyableInlineLink(
              text: AppStrings.phoneTwo,
              url: AppStrings.phoneTwoUrl,
              subject: 'telefone',
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
