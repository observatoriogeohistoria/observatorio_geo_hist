import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/breadcrumbs.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/page_header.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_blocks.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_column.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_page_scaffold.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';

/// Página Manifesto (spec 010), montada sobre a base de leitura.
class ManifestPage extends StatelessWidget {
  const ManifestPage({super.key});

  static const _lead =
      'O Observatório tem compromisso com a criação e democratização dos conhecimentos científicos, artísticos e pedagógicos. Nosso propósito é acompanhar, selecionar, produzir e disseminar conteúdos, especialmente sobre ensino e aprendizagem em História e Geografia.';

  static const _listIntro = 'O trabalho é movido pela inquietação e o desejo de:';

  static const _commitments = [
    'Desenvolver pesquisas de médio e longo prazos e matérias analíticas (artigos, livros, capítulos de livros, coletâneas, trabalhos apresentados e publicados em anais de eventos, teses, dissertações, monografias, vídeos e outros);',
    'Levantar, sistematizar e divulgar dados, informações, textos acadêmicos e jornalísticos, vídeos e outros artefatos da cultura, bem como relatos de experiências de ensino;',
    'Monitorar e avaliar as políticas públicas, a formação de professores (inicial e continuada), a produção de currículos e materiais didáticos relacionados ao ensino de História e Geografia;',
    'Acompanhar, promover e intervir nos debates públicos de questões relacionadas à História e à Geografia no âmbito cultural e educacional;',
    'Promover atividades de extensão e formação de professores, gestores de políticas e instituições educativas, pesquisadores e estudantes.',
  ];

  static const _closing =
      'O Observatório do Ensino de História e Geografia nasceu para produzir e divulgar conteúdos e experiências de qualidade e, sobretudo, aproximar, criar redes, reconectar quem atua com a História e a Geografia nas escolas e nas universidades.';

  static const _quote = 'Faça parte dessa criação!';

  @override
  Widget build(BuildContext context) {
    return ReadingPageScaffold(
      header: const PageHeader(
        breadcrumbs: [
          BreadcrumbItem('Início', route: AppRoutes.root),
          BreadcrumbItem('Manifesto'),
        ],
        title: 'Manifesto',
      ),
      body: ReadingColumn(
        children: [
          const ReadingLead(_lead),
          const ReadingParagraph(_listIntro),
          const ReadingNumberedList(items: _commitments),
          const ReadingParagraph(_closing),
          const ReadingQuote(_quote),
          Align(
            alignment: Alignment.centerLeft,
            child: PrimaryButton.medium(
              text: 'Fale com a gente',
              trailingIcon: Icons.arrow_forward,
              onPressed: () => context.go(AppRoutes.contact),
            ),
          ),
        ],
      ),
    );
  }
}
