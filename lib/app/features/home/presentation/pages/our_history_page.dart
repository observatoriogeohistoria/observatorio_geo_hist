import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/breadcrumbs.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/page_header.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_blocks.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_column.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_figure.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_page_scaffold.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/our_history/milestone_badge.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class OurHistoryPage extends StatelessWidget {
  const OurHistoryPage({super.key});

  static const _lead = 'Da pesquisa em Minas Gerais a um observatório aberto a todo o país.';

  static const _origin = [
    'O Observatório do Ensino de História e Geografia nasce da confluência entre o espírito acadêmico e o desejo de construir pontes entre pesquisadores, professores, estudantes e a sociedade brasileira, dentro e fora dos muros escolares e universitários.',
    'O Observatório foi idealizado e criado pelo Grupo de Estudos e Pesquisas em Ensino de Geografia – GEPEGH/UFU, vinculado à Linha de Pesquisa “Saberes e Práticas Educativas” do Programa de Pós-Graduação em Educação da Universidade Federal de Uberlândia, Minas Gerais, Brasil.',
    'O Observatório é um espaço formativo e colaborativo, fruto do Projeto de Pesquisa Coletivo, financiado pela FAPEMIG (2016–2018), intitulado “Observatório do Ensino de História e Geografia em Minas Gerais: políticas educacionais, formação docente e produção de conhecimentos”. O projeto foi desenvolvido por pesquisadores de diferentes níveis (IC, Mestrado e Doutorado), apoiado por diversas instituições.',
  ];

  static const _dimensionsIntro =
      'A investigação realizada se deteve no estudo das três dimensões do ensino de História e Geografia em Minas, as quais se refletiram na concepção deste Observatório:';

  static const _dimensions = [
    'as políticas públicas educacionais voltadas para o desenvolvimento do ensino e aprendizagem de História e Geografia implementadas pela Secretaria de Educação do estado (SEE/MG);',
    'a produção acadêmica (teses e dissertações) das Instituições de Ensino Superior (IES) públicas que focalizam o ensino de História e Geografia;',
    'o lugar do ensino de História e Geografia nos cursos de formação inicial de professores das IES públicas.',
  ];

  static const _beyond = [
    'Embora o foco inicial seja o nosso estado de Minas Gerais, entendemos que a missão deste espaço – que é, sobretudo, uma ferramenta para divulgação científica –, ultrapassa qualquer fronteira geográfica. Concebemos um Observatório capaz de interconectar diversas dimensões e realidades que permeiam a educação brasileira e o ensino de História e Geografia, congregando saberes, projetos, opiniões, experiências educativas e protagonistas de diferentes lugares.',
    'Para tanto, valorizamos e incentivamos a participação de todos e contamos com o poder multiplicador de cada pessoa, seja ela pesquisador, professor ou estudante.',
  ];

  /// Arredonda a largura para não decodificar a foto de novo a cada pixel de redimensionamento.
  static int _photoCacheWidth(BuildContext context) {
    const step = 256;
    final maxWidth = AppTheme.dimensions.components.readingFigureMaxWidth;
    final width = math.min(MediaQuery.sizeOf(context).width, maxWidth) *
        MediaQuery.devicePixelRatioOf(context);
    return (width / step).ceil() * step;
  }

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;

    return ReadingPageScaffold(
      header: const PageHeader(
        breadcrumbs: [
          BreadcrumbItem('Início', route: AppRoutes.root),
          BreadcrumbItem('Nossa história'),
        ],
        title: 'Nossa história',
        lead: _lead,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReadingFigure(
            image: ResizeImage(
              const AssetImage('${AppAssets.images}/our-history.webp'),
              width: _photoCacheWidth(context),
            ),
            semanticLabel: 'Foto de grupo dos pesquisadores do Observatório',
            caption: 'Foto: Antônio César Ortega',
            // Puxa o recorte para cima para não cortar os rostos da foto de grupo.
            alignment: const Alignment(0, -0.7),
          ),
          ReadingColumn(
            paddingTop: components.readingFigureMarginBottom,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: MilestoneBadge(text: 'Projeto financiado pela FAPEMIG · 2016⁠–⁠2018'),
              ),
              SizedBox(height: components.ourHistoryTextGap),
              for (final paragraph in _origin) ReadingParagraph(paragraph),
              const ReadingSubtitle('As três dimensões investigadas'),
              const ReadingParagraph(_dimensionsIntro),
              const ReadingBulletList(items: _dimensions),
              const ReadingSubtitle('Para além de Minas Gerais'),
              for (final paragraph in _beyond) ReadingParagraph(paragraph),
            ],
          ),
        ],
      ),
    );
  }
}
