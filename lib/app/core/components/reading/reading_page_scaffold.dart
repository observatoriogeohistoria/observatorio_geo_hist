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
        // Keeps the navbar first in Tab order, even with the page scrolled.
        policy: OrderedTraversalPolicy(
          secondary: ReadingOrderTraversalPolicy(requestFocusCallback: _focusAndReveal),
          requestFocusCallback: _focusAndReveal,
        ),
        child: CustomScrollView(
          slivers: [
            const FocusTraversalOrder(order: NumericFocusOrder(0), child: NavbarSliver()),
            if (header != null) SliverToBoxAdapter(child: header),
            SliverToBoxAdapter(child: body),
            // SliverFillRemaining would measure the intrinsic height, which the support section's LayoutBuilder doesn't allow.
            SliverLayoutBuilder(
              builder: (context, constraints) {
                final remaining =
                    constraints.viewportMainAxisExtent - constraints.precedingScrollExtent;
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

// The default only scrolls in the Tab direction: a link above the screen or under the fixed navbar
// got focus without showing up.
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
  Scrollable.ensureVisible(context,
      alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart);
}
