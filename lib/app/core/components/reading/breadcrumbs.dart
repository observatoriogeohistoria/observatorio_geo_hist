import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Um nível das migalhas. Sem [route], é a página atual.
class BreadcrumbItem {
  const BreadcrumbItem(this.label, {this.route});

  final String label;
  final String? route;
}

/// Migalhas do cabeçalho de página (`.crumbs`): níveis com link, separados por
/// seta, e o último como página atual, sem link.
class Breadcrumbs extends StatelessWidget {
  const Breadcrumbs({super.key, required this.items});

  final List<BreadcrumbItem> items;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final style = AppTheme.typography.of(context).small;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Você está em',
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: components.breadcrumbGap,
        runSpacing: components.breadcrumbGap,
        children: [
          for (final (index, item) in items.indexed)
            // A seta vai junto do item seguinte para não sobrar sozinha no fim da linha.
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (index > 0) ...[
                  ExcludeSemantics(
                    child: Icon(
                      Icons.chevron_right,
                      size: components.breadcrumbIcon * MediaQuery.textScalerOf(context).scale(1),
                      color: colors.inkSecondary,
                    ),
                  ),
                  SizedBox(width: components.breadcrumbGap),
                ],
                Flexible(
                  child: index == items.length - 1 || item.route == null
                      ? Semantics(
                          label: '${item.label}, página atual',
                          excludeSemantics: true,
                          child: Text(item.label, style: style.copyWith(color: colors.ink, fontWeight: FontWeight.w600)),
                        )
                      : _BreadcrumbLink(label: item.label, route: item.route!, style: style),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _BreadcrumbLink extends StatefulWidget {
  const _BreadcrumbLink({required this.label, required this.route, required this.style});

  final String label;
  final String route;
  final TextStyle style;

  @override
  State<_BreadcrumbLink> createState() => _BreadcrumbLinkState();
}

class _BreadcrumbLinkState extends State<_BreadcrumbLink> {
  bool _hovered = false;

  void _open() => context.go(widget.route);

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r6);
    final color = _hovered ? colors.accentStrong : colors.inkSecondary;

    return Semantics(
      link: true,
      label: widget.label,
      linkUrl: Uri.parse(widget.route),
      // Repete a ação do InkWell (excluído da semântica) para o leitor de tela ativar o link.
      onTap: _open,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: _open,
            onHover: (value) => setState(() => _hovered = value),
            borderRadius: radius,
            splashFactory: NoSplash.splashFactory,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            mouseCursor: SystemMouseCursors.click,
            child: Text(
              widget.label,
              style: widget.style.copyWith(
                color: color,
                decoration: _hovered ? TextDecoration.underline : TextDecoration.none,
                decorationColor: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
