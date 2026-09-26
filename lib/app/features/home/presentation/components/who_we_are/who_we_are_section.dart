import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/arrow_link.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/who_we_are/audience_item.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Seção "Quem somos" da Home (spec 006): missão do Observatório, link para o
/// manifesto e os três públicos. Estática, aparece junto com a página.
///
/// Desktop: duas colunas (apresentação 1 : públicos 1,15) alinhadas pelo topo.
/// Tablet e celular (e desktop com texto muito ampliado): uma coluna,
/// apresentação e depois públicos.
class WhoWeAreSection extends StatelessWidget {
  const WhoWeAreSection({super.key});

  static const _manifestRoute = '/manifest';

  static const _audiences = [
    (
      icon: Icons.edit_outlined,
      name: 'Professores',
      description: 'Experiências didáticas e materiais para levar à sala de aula.',
    ),
    (
      icon: Icons.science_outlined,
      name: 'Pesquisadores',
      description: 'Teses, dissertações e pesquisas de várias instituições, reunidas.',
    ),
    (
      icon: Icons.school_outlined,
      name: 'Estudantes',
      description: 'Um ponto de partida para aprofundar práticas e saberes educativos.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);
    // Com o texto muito ampliado, a coluna da apresentação fica estreita demais
    // para o título: a seção passa para uma coluna, como no tablet.
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= components.whoWeAreStackTextScale;
    final twoColumns = breakpoint == Breakpoint.desktop && !largeText;
    final gap = components.whoWeAreGap(
      breakpoint == Breakpoint.desktop && !twoColumns ? Breakpoint.tablet : breakpoint,
    );

    const intro = _Intro(onOpenManifest: _openManifest);
    final audiences = Padding(
      padding: EdgeInsets.only(top: components.audienceListTop),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, audience) in _audiences.indexed) ...[
            if (index > 0) SizedBox(height: components.audienceItemGap),
            AudienceItem(
              icon: audience.icon,
              name: audience.name,
              description: audience.description,
              isLast: index == _audiences.length - 1,
            ),
          ],
        ],
      ),
    );

    return ColoredBox(
      color: AppTheme.colors.surface,
      child: PageContent(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: components.sectionPaddingVertical(breakpoint)),
          child: twoColumns
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: components.whoWeAreIntroFlex, child: intro),
                    SizedBox(width: gap),
                    Expanded(flex: components.whoWeAreAudienceFlex, child: audiences),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [intro, SizedBox(height: gap), audiences],
                ),
        ),
      ),
    );
  }

  static void _openManifest(BuildContext context) => GoRouter.of(context).go(_manifestRoute);
}

/// Rótulo, título, texto de missão e link para o manifesto.
class _Intro extends StatelessWidget {
  const _Intro({required this.onOpenManifest});

  final void Function(BuildContext context) onOpenManifest;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quem somos'.toUpperCase(), style: styles.label.copyWith(color: colors.accentStrong)),
        SizedBox(height: components.whoWeAreTitleGap),
        Semantics(
          header: true,
          child: Text(
            'Um espaço para acessar, compartilhar e produzir conhecimento.',
            style: styles.splitTitle.copyWith(color: colors.ink),
          ),
        ),
        SizedBox(height: components.whoWeAreTextGap),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: components.whoWeAreTextMaxWidth),
          child: Text(
            'Nossa missão é divulgar saberes relevantes e fazer circular conhecimentos que contribuam '
            'para a formação permanente de quem atua no ensino de História, Geografia e áreas afins.',
            style: styles.sectionLead.copyWith(color: colors.inkSecondary),
          ),
        ),
        SizedBox(height: components.whoWeAreLinkGap),
        ArrowLink(text: 'Conheça o manifesto', onTap: () => onOpenManifest(context)),
      ],
    );
  }
}
