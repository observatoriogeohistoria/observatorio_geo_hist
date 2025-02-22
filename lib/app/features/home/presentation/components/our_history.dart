import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_label.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/common/title_widget.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class OurHistory extends StatelessWidget {
  const OurHistory({super.key});

  @override
  Widget build(BuildContext context) {
    const firstText =
        'O Observatório do Ensino de História e Geografia nasce da confluência entre o espírito acadêmico e o desejo de construir pontes entre pesquisadores, professores, estudantes e a sociedade brasileira, dentro e fora dos muros escolares e universitários. O Observatório foi idealizado e criado pelo Grupo de Estudos e Pesquisas em Ensino de Geografia – GEPEGH/UFU, vinculado à Linha de Pesquisa “Saberes e Práticas Educativas” do Programa de Pós-Graduação em Educação da Universidade Federal de Uberlândia, Minas Gerais, Brasil. O Observatório é um espaço formativo e colaborativo, fruto do Projeto de Pesquisa Coletivo, financiado pela FAPEMIG (2016-2018), intitulado “Observatório do Ensino de História e Geografia em Minas Gerais: políticas educacionais, formação docente e produção de conhecimentos”. O projeto foi desenvolvido por pesquisadores de diferentes níveis (IC, Mestrado e Doutorado), apoiado por diversas instituições.';

    const secondText =
        '''A investigação realizada se deteve no estudo das três dimensões do ensino de História e Geografia em Minas, as quais se refletiram na concepção deste Observatório: as políticas públicas educacionais voltadas para o desenvolvimento do ensino e aprendizagem de História e Geografia implementadas pela Secretaria de Educação do estado (SEE/MG); a produção acadêmica (teses e dissertações) das Instituições de Ensino Superior (IES) públicas que focalizam o ensino de História e Geografia; e, por fim, o lugar do ensino de História e Geografia nos cursos de formação inicial de professores das IES públicas.

Embora o foco inicial seja o nosso estado de Minas Gerais, entendemos que a missão deste espaço – que é, sobretudo, uma ferramenta para divulgação científica –, ultrapassa qualquer fronteira geográfica. Concebemos um Observatório capaz de interconectar diversas dimensões e realidades que permeiam a educação brasileira e o ensino de História e Geografia, congregando saberes, projetos, opiniões, experiências educativas e protagonistas de diferentes lugares. Para tanto, valorizamos e incentivamos a participação de todos e contamos com o poder multiplicador de cada pessoa, seja ela pesquisador, professor ou estudante.''';

    final padding = MediaQuery.of(context).size.height * 0.2;
    final space = SizedBox(height: AppTheme.dimensions.space.large);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: padding,
            vertical: AppTheme.dimensions.space.medium,
          ),
          width: double.infinity,
          color: AppTheme.colors.gray,
          child: Center(
            child: TitleWidget(
              title: 'NOSSA HISTÓRIA',
              color: AppTheme.colors.white,
            ),
          ),
        ),
        space,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            children: [
              AppBody(
                text: firstText,
                color: AppTheme.colors.darkGray,
              ),
              space,
              Column(
                children: [
                  Image.asset(
                    'assets/images/our-history.jpg',
                  ),
                  SizedBox(height: AppTheme.dimensions.space.small),
                  AppLabel(
                    text: 'Foto: Antônio César Ortega',
                    color: AppTheme.colors.darkGray,
                  ),
                ],
              ),
              space,
              AppBody(
                text: secondText,
                color: AppTheme.colors.darkGray,
              ),
            ],
          ),
        ),
        space,
      ],
    );
  }
}
