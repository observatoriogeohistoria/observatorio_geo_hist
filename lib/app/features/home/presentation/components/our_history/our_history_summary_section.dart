import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/arrow_link.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/our_history/milestone_badge.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Resumo de Nossa história na Home (spec 007), com link para a página
/// completa. Estático, aparece junto com a página.
class OurHistorySummarySection extends StatelessWidget {
  const OurHistorySummarySection({super.key});

  static const _paragraphs = [
    'O Observatório nasce da confluência entre o espírito acadêmico e o desejo de construir pontes entre '
        'pesquisadores, professores, estudantes e a sociedade. Foi idealizado pelo Grupo de Estudos e Pesquisas '
        'em Ensino de Geografia (GEPEGH/UFU), vinculado ao Programa de Pós-Graduação em Educação da '
        'Universidade Federal de Uberlândia.',
    'Embora o foco inicial seja Minas Gerais, sua missão ultrapassa qualquer fronteira geográfica: uma '
        'ferramenta de divulgação científica que valoriza a participação de todos.',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final breakpoint = ScreenUtils.breakpointOf(context);
    final readingStyle = styles.reading.copyWith(color: colors.ink);

    return ColoredBox(
      color: colors.surface,
      child: PageContent(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: components.sectionPaddingVertical(breakpoint)),
          child: Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: components.ourHistorySummaryMaxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nossa história'.toUpperCase(), style: styles.label.copyWith(color: colors.accentStrong)),
                  SizedBox(height: components.ourHistoryTitleGap),
                  Semantics(
                    header: true,
                    child: Text(
                      'Da pesquisa em Minas Gerais a um observatório aberto.',
                      style: styles.splitTitle.copyWith(color: colors.ink),
                    ),
                  ),
                  SizedBox(height: components.ourHistoryBadgeGap),
                  // Espaço rígido e \u2060 mantêm "· 2016–2018" inteiro na mesma linha.
                  const MilestoneBadge(text: 'Projeto financiado pela FAPEMIG ·\u00a02016\u2060–\u20602018'),
                  SizedBox(height: components.ourHistoryTextGap),
                  for (final (index, paragraph) in _paragraphs.indexed) ...[
                    if (index > 0) SizedBox(height: components.readingParagraphGap),
                    Text(paragraph, style: readingStyle),
                  ],
                  SizedBox(height: components.ourHistoryLinkGap),
                  ArrowLink(
                    text: 'Ler a história completa',
                    onTap: () => GoRouter.of(context).go(AppRoutes.ourHistory),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
