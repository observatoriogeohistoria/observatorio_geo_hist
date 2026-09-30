import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Link de texto com seta (`.link-arrow` do protótipo), sem preenchimento.
///
/// Texto em laranja forte (acima de 4,5:1 também sobre a superfície `#F7F5F2`)
/// e seta decorativa, que se afasta um pouco do texto no hover. O leitor de
/// tela ouve só o [text], como link.
class ArrowLink extends StatefulWidget {
  const ArrowLink({super.key, required this.text, required this.onTap, this.url});

  final String text;
  final VoidCallback onTap;

  /// Endereço de destino, para o leitor de tela anunciar o link.
  final String? url;

  @override
  State<ArrowLink> createState() => _ArrowLinkState();
}

class _ArrowLinkState extends State<ArrowLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final color = AppTheme.colors.accentStrong;
    final style = AppTheme.typography.of(context).regular.copyWith(fontWeight: FontWeight.w600, color: color);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r6);

    return Semantics(
      link: true,
      label: widget.text,
      linkUrl: widget.url == null ? null : Uri.parse(widget.url!),
      // Repete a ação do InkWell (excluído da semântica) para o leitor de tela ativar o link.
      onTap: widget.onTap,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: widget.onTap,
            onHover: (value) => setState(() => _hovered = value),
            borderRadius: radius,
            splashFactory: NoSplash.splashFactory,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            mouseCursor: SystemMouseCursors.click,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(child: Text(widget.text, style: style)),
                AnimatedContainer(
                  duration: reduceMotion ? Duration.zero : components.arrowLinkAnimation,
                  width: _hovered ? components.arrowLinkGapHover : components.arrowLinkGap,
                ),
                Icon(
                  Icons.arrow_forward,
                  size: style.fontSize! * components.buttonIconScale,
                  color: color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
