import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class ReadingPageScaffold extends StatelessWidget {
  const ReadingPageScaffold({super.key, this.header, required this.body, this.beforeFooter});

  final Widget? header;
  final Widget body;

  final Widget? beforeFooter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.page,
      body: FocusTraversalGroup(
        // Mantém a navbar primeiro no Tab, mesmo com a página rolada.
        policy: OrderedTraversalPolicy(
          secondary: ReadingOrderTraversalPolicy(requestFocusCallback: _focusAndReveal),
          requestFocusCallback: _focusAndReveal,
        ),
        child: CustomScrollView(
          slivers: [
            const FocusTraversalOrder(order: NumericFocusOrder(0), child: NavbarSliver()),
            if (header != null) SliverToBoxAdapter(child: header),
            SliverToBoxAdapter(child: body),
            // SliverFillRemaining mediria a altura intrínseca, que o LayoutBuilder do Apoio não suporta.
            SliverLayoutBuilder(
              builder: (context, constraints) {
                final remaining = constraints.viewportMainAxisExtent - constraints.precedingScrollExtent;
                return SliverToBoxAdapter(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: remaining > 0 ? remaining : 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [if (beforeFooter != null) beforeFooter!, const Footer()],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// O padrão só rola no sentido do Tab: um link acima da tela ou sob a navbar fixa
// recebia foco sem aparecer.
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
