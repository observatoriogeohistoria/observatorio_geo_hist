import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Esqueleto das páginas de leitura: navbar, cabeçalho opcional, corpo e
/// rodapé, que fica na base da janela quando a página é curta.
class ReadingPageScaffold extends StatelessWidget {
  const ReadingPageScaffold({super.key, this.header, required this.body, this.beforeFooter});

  final Widget? header;
  final Widget body;

  /// Faixa colada ao rodapé, que desce com ele quando a página é curta (a
  /// seção Apoio do post).
  final Widget? beforeFooter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.page,
      body: FocusTraversalGroup(
        // A navbar vem antes no Tab mesmo com a página rolada e as migalhas sob ela.
        policy: OrderedTraversalPolicy(
          secondary: ReadingOrderTraversalPolicy(requestFocusCallback: _focusAndReveal),
          requestFocusCallback: _focusAndReveal,
        ),
        child: CustomScrollView(
          slivers: [
            const FocusTraversalOrder(order: NumericFocusOrder(0), child: NavbarSliver()),
            if (header != null) SliverToBoxAdapter(child: header),
            SliverToBoxAdapter(child: body),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [const Spacer(), if (beforeFooter != null) beforeFooter!, const Footer()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// O padrão só rola no sentido do Tab: um link acima da tela ou sob a navbar
// fixa (as migalhas, com a página rolada) recebia foco sem aparecer.
void _focusAndReveal(
  FocusNode node, {
  ScrollPositionAlignmentPolicy? alignmentPolicy,
  double? alignment,
  Duration? duration,
  Curve? curve,
}) {
  FocusTraversalPolicy.defaultTraversalRequestFocusCallback(
    node,
    alignmentPolicy: alignmentPolicy,
    alignment: alignment,
    duration: duration,
    curve: curve,
  );
  final context = node.context;
  if (context == null || !context.mounted) return;
  Scrollable.ensureVisible(context, alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart);
}
