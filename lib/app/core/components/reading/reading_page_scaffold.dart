import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Esqueleto das páginas de leitura: navbar, cabeçalho opcional, corpo e
/// rodapé, que fica na base da janela quando a página é curta.
class ReadingPageScaffold extends StatelessWidget {
  const ReadingPageScaffold({super.key, this.header, required this.body});

  final Widget? header;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.page,
      body: CustomScrollView(
        slivers: [
          const NavbarSliver(),
          if (header != null) SliverToBoxAdapter(child: header),
          SliverToBoxAdapter(child: body),
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
