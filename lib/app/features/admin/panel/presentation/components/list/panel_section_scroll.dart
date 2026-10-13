import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/scroll/app_scrollbar.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Cabeçalho, filtros e lista rolam juntos. [onNearEnd] avisa quando falta pouco para o fim.
class PanelSectionScroll extends StatefulWidget {
  const PanelSectionScroll({
    required this.header,
    required this.body,
    this.filterBar,
    this.onNearEnd,
    this.controller,
    super.key,
  });

  final Widget header;
  final Widget? filterBar;

  /// Um sliver: a lista, a grade, o esqueleto ou uma caixa de estado.
  final Widget body;
  final VoidCallback? onNearEnd;
  final ScrollController? controller;

  @override
  State<PanelSectionScroll> createState() => _PanelSectionScrollState();
}

class _PanelSectionScrollState extends State<PanelSectionScroll> {
  late final ScrollController _ownController = ScrollController();

  ScrollController get _controller => widget.controller ?? _ownController;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleScroll);
  }

  @override
  void didUpdateWidget(covariant PanelSectionScroll oldWidget) {
    super.didUpdateWidget(oldWidget);
    final old = oldWidget.controller ?? _ownController;
    if (old != _controller) {
      old.removeListener(_handleScroll);
      _controller.addListener(_handleScroll);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleScroll);
    _ownController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    final onNearEnd = widget.onNearEnd;
    if (onNearEnd == null || !_controller.hasClients) return;
    final position = _controller.position;
    final trigger = AppTheme.dimensions.components.panelLoadMoreTrigger;
    if (position.pixels >= position.maxScrollExtent - trigger) onNearEnd();
  }

  @override
  Widget build(BuildContext context) {
    final filterBar = widget.filterBar;

    return AppScrollbar(
      controller: _controller,
      child: CustomScrollView(
        controller: _controller,
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: widget.header),
          if (filterBar != null) SliverToBoxAdapter(child: filterBar),
          widget.body,
          SliverToBoxAdapter(
            child: SizedBox(height: AppTheme.dimensions.components.panelMainPaddingBottom),
          ),
        ],
      ),
    );
  }
}

/// Quando a primeira página não enche a tela, não há rolagem para pedir a próxima.
void loadMoreIfNotScrollable(ScrollController controller, VoidCallback loadMore) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!controller.hasClients) return;
    final position = controller.position;
    if (position.maxScrollExtent <= AppTheme.dimensions.components.panelLoadMoreTrigger) {
      loadMore();
    }
  });
}
