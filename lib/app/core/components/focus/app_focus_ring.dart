import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Desenha o contorno de foco visível (3 px, afastado 2 px, cor de acento)
/// ao redor de [child] quando algum widget dentro dele recebe foco pelo
/// teclado. Não altera o layout e não aparece no clique do mouse. O texto de
/// [child] fica fora da seleção, como em todo elemento clicável.
class AppFocusRing extends StatefulWidget {
  const AppFocusRing({
    super.key,
    required this.child,
    this.borderRadius = BorderRadius.zero,
    this.color,
    this.fit = StackFit.loose,
  });

  final Widget child;

  /// Raio do elemento envolvido. O contorno soma o afastamento e a espessura.
  final BorderRadius borderRadius;

  /// Cor do contorno. Por padrão, a cor de acento; use outra sobre fundo escuro.
  final Color? color;

  /// Como as restrições do pai chegam ao [child]. Use `StackFit.passthrough`
  /// quando o filho precisa ocupar a altura imposta pelo pai (por exemplo,
  /// cartões de mesma altura numa `Row` com `IntrinsicHeight`).
  final StackFit fit;

  @override
  State<AppFocusRing> createState() => _AppFocusRingState();
}

class _AppFocusRingState extends State<AppFocusRing> {
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    FocusManager.instance.addHighlightModeListener(_handleHighlightModeChange);
  }

  @override
  void dispose() {
    FocusManager.instance.removeHighlightModeListener(_handleHighlightModeChange);
    super.dispose();
  }

  /// Alternar entre mouse e teclado sem mudar o foco também mostra/esconde o anel.
  void _handleHighlightModeChange(FocusHighlightMode mode) {
    if (_hasFocus && mounted) setState(() {});
  }

  void _handleFocusChange(bool hasFocus) {
    if (_hasFocus != hasFocus) setState(() => _hasFocus = hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final focus = AppTheme.dimensions.focus;
    final outset = focus.width + focus.offset;
    final showRing = _hasFocus && FocusManager.instance.highlightMode == FocusHighlightMode.traditional;

    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: _handleFocusChange,
      child: Stack(
        fit: widget.fit,
        clipBehavior: Clip.none,
        children: [
          SelectionContainer.disabled(child: widget.child),
          if (showRing)
            Positioned(
              left: -outset,
              top: -outset,
              right: -outset,
              bottom: -outset,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: _grow(widget.borderRadius.topLeft, outset),
                      topRight: _grow(widget.borderRadius.topRight, outset),
                      bottomLeft: _grow(widget.borderRadius.bottomLeft, outset),
                      bottomRight: _grow(widget.borderRadius.bottomRight, outset),
                    ),
                    border: Border.all(color: widget.color ?? focus.color, width: focus.width),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Radius _grow(Radius radius, double by) => radius == Radius.zero ? Radius.zero : Radius.circular(radius.x + by);
}
