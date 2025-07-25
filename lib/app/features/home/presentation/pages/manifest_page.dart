import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/divider/divider.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class ManifestPage extends StatefulWidget {
  const ManifestPage({super.key});

  @override
  State<ManifestPage> createState() => _ManifestPageState();
}

class _ManifestPageState extends State<ManifestPage> {
  @override
  Widget build(BuildContext context) {
    SizedBox space = SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing);

    return Scaffold(
      backgroundColor: AppTheme.colors.white,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: Navbar()),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtils.getPageHorizontalPadding(context),
                vertical: AppTheme.dimensions.space.massive.verticalSpacing,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppHeadline.medium(
                    text: 'MANIFESTO',
                    color: AppTheme.colors.orange,
                  ),
                  const AppDivider(),
                  space,
                  AppBody.big(
                    text:
                        'O Observatório tem compromisso com a criação e democratização dos conhecimentos científicos, artísticos e pedagógicos. Nosso propósito é acompanhar, selecionar, produzir e disseminar conteúdos, especialmente, sobre  ensino e aprendizagem em História e Geografia. O trabalho é movido pela inquietação e o desejo de:',
                    color: AppTheme.colors.gray,
                  ),
                  space,
                  AppBody.big(
                    text:
                        '1) Desenvolver pesquisas de médio e longo prazos e matérias analíticas (artigos, livros, capítulos de livros, coletâneas, trabalhos apresentados e publicados em anais de eventos, teses, dissertações, monografias, vídeos e outros);',
                    color: AppTheme.colors.gray,
                  ),
                  space,
                  AppBody.big(
                    text:
                        '2) Levantar, sistematizar e divulgar dados, informações, textos acadêmicos e jornalísticos, vídeos e outros artefatos da cultura, bem como relatos de experiências de ensino;',
                    color: AppTheme.colors.gray,
                  ),
                  space,
                  AppBody.big(
                    text:
                        '3) Monitorar e avaliar as políticas públicas, a formação de professores (inicial e continuada), a produção de currículos e materiais didáticos relacionados  ao ensino de História e Geografia;',
                    color: AppTheme.colors.gray,
                  ),
                  space,
                  AppBody.big(
                    text:
                        '4) Acompanhar, promover e intervir nos debates públicos de questões relacionadas à História e à Geografia no âmbito cultural e educacional;',
                    color: AppTheme.colors.gray,
                  ),
                  space,
                  AppBody.big(
                    text:
                        '5) Promover atividades de extensão/formação de professores, gestores de políticas e instituições educativas, pesquisadores, estudantes.',
                    color: AppTheme.colors.gray,
                  ),
                  space,
                  AppBody.big(
                    text:
                        'O Observatório do Ensino de História e Geografia nasceu para produzir e divulgar conteúdos e experiências  de qualidade e, sobretudo, aproximar, criar redes, reconectar quem atua com a História e a Geografia nas escolas e nas universidades. Faça parte dessa criação!',
                    color: AppTheme.colors.gray,
                  ),
                ],
              ),
            ),
          ),
          const SliverFillRemaining(hasScrollBody: false, child: SizedBox.shrink()),
          const SliverToBoxAdapter(child: Footer()),
        ],
      ),
    );
  }
}
