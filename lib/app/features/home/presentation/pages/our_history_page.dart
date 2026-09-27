import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Página Nossa história (spec 007). Provisória: o texto completo de sempre,
/// sem alteração; o redesenho da página fica para a Fase 2.
class OurHistoryPage extends StatelessWidget {
  const OurHistoryPage({super.key});

  static const _paragraphs = [
    'O Observatório do Ensino de História e Geografia nasce da confluência entre o espírito acadêmico e o desejo de construir pontes entre pesquisadores, professores, estudantes e a sociedade brasileira, dentro e fora dos muros escolares e universitários. O Observatório foi idealizado e criado pelo Grupo de Estudos e Pesquisas em Ensino de Geografia – GEPEGH/UFU, vinculado à Linha de Pesquisa “Saberes e Práticas Educativas” do Programa de Pós-Graduação em Educação da Universidade Federal de Uberlândia, Minas Gerais, Brasil. O Observatório é um espaço formativo e colaborativo, fruto do Projeto de Pesquisa Coletivo, financiado pela FAPEMIG (2016-2018), intitulado “Observatório do Ensino de História e Geografia em Minas Gerais: políticas educacionais, formação docente e produção de conhecimentos”. O projeto foi desenvolvido por pesquisadores de diferentes níveis (IC, Mestrado e Doutorado), apoiado por diversas instituições.',
    'A investigação realizada se deteve no estudo das três dimensões do ensino de História e Geografia em Minas, as quais se refletiram na concepção deste Observatório: as políticas públicas educacionais voltadas para o desenvolvimento do ensino e aprendizagem de História e Geografia implementadas pela Secretaria de Educação do estado (SEE/MG); a produção acadêmica (teses e dissertações) das Instituições de Ensino Superior (IES) públicas que focalizam o ensino de História e Geografia; e, por fim, o lugar do ensino de História e Geografia nos cursos de formação inicial de professores das IES públicas.',
    'Embora o foco inicial seja o nosso estado de Minas Gerais, entendemos que a missão deste espaço – que é, sobretudo, uma ferramenta para divulgação científica –, ultrapassa qualquer fronteira geográfica. Concebemos um Observatório capaz de interconectar diversas dimensões e realidades que permeiam a educação brasileira e o ensino de História e Geografia, congregando saberes, projetos, opiniões, experiências educativas e protagonistas de diferentes lugares. Para tanto, valorizamos e incentivamos a participação de todos e contamos com o poder multiplicador de cada pessoa, seja ela pesquisador, professor ou estudante.',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final breakpoint = ScreenUtils.breakpointOf(context);
    final readingStyle = styles.reading.copyWith(color: colors.ink);

    return Scaffold(
      backgroundColor: colors.page,
      body: CustomScrollView(
        slivers: [
          const NavbarSliver(),
          SliverToBoxAdapter(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border(bottom: BorderSide(color: colors.line)),
              ),
              child: PageContent(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: components.pageHeadPaddingVertical(breakpoint)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Semantics(
                      header: true,
                      child: Text('Nossa história', style: styles.h1.copyWith(color: colors.ink)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: PageContent(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: components.sectionPaddingVertical(breakpoint)),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: components.readingMaxWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final (index, paragraph) in _paragraphs.indexed) ...[
                          if (index > 0) SizedBox(height: components.readingParagraphGap),
                          Text(paragraph, style: readingStyle),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [Spacer(), Footer()],
            ),
          ),
        ],
      ),
    );
  }
}
