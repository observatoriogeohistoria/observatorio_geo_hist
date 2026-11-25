import 'package:flutter/widgets.dart';
import 'package:observatorio_geo_hist/app/core/utils/browser/page_meta.dart';
import 'package:observatorio_geo_hist/app/core/utils/environment/app_environment.dart';

/// Applies the route's title, description and canonical while the page is on screen.
class PageMetaScope extends StatefulWidget {
  const PageMetaScope({super.key, required this.meta, required this.child});

  final PageMeta meta;
  final Widget child;

  @override
  State<PageMetaScope> createState() => _PageMetaScopeState();
}

class _PageMetaScopeState extends State<PageMetaScope> {
  @override
  void initState() {
    super.initState();
    _apply();
  }

  @override
  void didUpdateWidget(PageMetaScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    final old = oldWidget.meta;
    final meta = widget.meta;
    if (old.path != meta.path ||
        old.title != meta.title ||
        old.description != meta.description ||
        old.noIndex != meta.noIndex) {
      _apply();
    }
  }

  void _apply() => applyPageMeta(widget.meta, isProd: AppEnvironment.current.isProd);

  @override
  Widget build(BuildContext context) => widget.child;
}
