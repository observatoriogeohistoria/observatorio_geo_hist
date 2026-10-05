import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/inline_link.dart';
import 'package:observatorio_geo_hist/app/core/components/form/mail_aside_card.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_strings.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class CollaborateGuideCard extends StatelessWidget {
  const CollaborateGuideCard({super.key});

  @override
  Widget build(BuildContext context) {
    final style = AppTheme.typography.of(context).regular.copyWith(color: AppTheme.colors.ink);

    return MailAsideCard(
      title: 'Antes de enviar',
      children: [
        MailAsideItem(
          label: 'O que enviar',
          children: [
            Text(
              'Artigos de opinião, relatos de experiência, produções acadêmicas e sugestões de materiais.',
              style: style,
            ),
          ],
        ),
        MailAsideItem(
          label: 'Arquivos',
          children: [
            Text(
              'Texto, áudio ou vídeo, em formatos de uso comum, como .pdf, .doc, .odt, .mp3, .mp4 e .jpg.',
              style: style,
            ),
          ],
        ),
        MailAsideItem(
          label: 'Criações de terceiros',
          children: [
            Text(
              'Se o seu material usa obras de outras pessoas, confira se os termos de uso permitem a redistribuição.',
              style: style,
            ),
          ],
        ),
        MailAsideItem(
          label: 'Avaliação',
          children: [
            Text('Depois de avaliado, o material é publicado no Observatório.', style: style),
          ],
        ),
        MailAsideItem(
          label: 'Licença',
          children: [
            Text(
              'Exceto quando indicado, o conteúdo do Observatório segue a licença Creative Commons Atribuição-NãoComercial-CompartilhaIgual 4.0 Internacional: pode ser compartilhado e remixado, com atribuição de autoria, para fins não comerciais e sob os mesmos termos.',
              style: style,
            ),
            SizedBox(height: AppTheme.dimensions.components.contactInfoLabelGap),
            const InlineLink(
              text: 'Conheça as licenças Creative Commons',
              url: AppStrings.creativeCommonsUrl,
              semanticLabel: 'Conheça as licenças Creative Commons, abre em outra aba',
            ),
          ],
        ),
        const MailAsideItem(
          label: 'E-mail',
          children: [InlineLink(text: AppStrings.email, url: AppStrings.emailUrl)],
        ),
      ],
    );
  }
}
