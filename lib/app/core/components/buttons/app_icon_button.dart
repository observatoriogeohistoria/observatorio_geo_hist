import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class AppIconButton extends StatefulWidget {
  const AppIconButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.tooltip,
    this.label,
    this.size = 24,
    this.focusNode,
    this.focusRingColor,
    this.isDisabled = false,
    this.isToggled,
    super.key,
  });

  final IconData icon;
  final Color color;
  final void Function() onPressed;

  /// Descrição do que acontece, mostrada no mouse e no foco por teclado.
  final String tooltip;

  /// Nome curto para o leitor de tela ("Excluir"); sem ele, vale o [tooltip].
  final String? label;

  final double size;

  final FocusNode? focusNode;

  /// Sobre fundo de acento, o anel padrão some; use uma cor que contraste com o fundo.
  final Color? focusRingColor;

  /// Continua focável para a pessoa chegar por Tab e ler na dica por que não dá.
  final bool isDisabled;

  /// Para botões que ligam e desligam (destacar): o leitor anuncia se está ligado.
  final bool? isToggled;

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  final _tooltipKey = GlobalKey<TooltipState>();
  FocusNode? _ownFocusNode;
  bool _focused = false;

  FocusNode get _focusNode => widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void dispose() {
    _ownFocusNode?.dispose();
    super.dispose();
  }

  void _handleFocusChange(bool hasFocus) {
    setState(() => _focused = hasFocus);
    if (!hasFocus) {
      Tooltip.dismissAllToolTips();
      return;
    }
    if (FocusManager.instance.highlightMode != FocusHighlightMode.traditional) return;
    // Com o leitor de tela a dica já vai no nome do botão, e abrir a camada dela tira o foco do
    // navegador do botão.
    if (SemanticsBinding.instance.semanticsEnabled) return;

    // Depois do quadro, para não ser fechada pelo botão que acabou de perder o foco.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _tooltipKey.currentState?.ensureTooltipVisible();
    });
  }

  // O Esc só é consumido quando havia dica aberta; senão segue para a gaveta ou o diálogo.
  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || event.logicalKey != LogicalKeyboardKey.escape) {
      return KeyEventResult.ignored;
    }
    return Tooltip.dismissAllToolTips() ? KeyEventResult.handled : KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final minTarget = components.minTapTarget;
    final disabled = widget.isDisabled;
    final label = widget.label ?? widget.tooltip;

    return Semantics(
      button: true,
      enabled: !disabled,
      toggled: widget.isToggled,
      label: label,
      tooltip: label == widget.tooltip ? null : widget.tooltip,
      onTap: disabled ? null : widget.onPressed,
      // Sem o nó do IconButton, o foco precisa estar neste; senão, com o leitor de tela ligado,
      // o navegador perde o foco ao chegar no botão.
      focusable: true,
      focused: _focused,
      onFocus: _focusNode.requestFocus,
      excludeSemantics: true,
      child: Focus(
        canRequestFocus: false,
        skipTraversal: true,
        onFocusChange: _handleFocusChange,
        onKeyEvent: _handleKey,
        child: Tooltip(
          key: _tooltipKey,
          message: widget.tooltip,
          excludeFromSemantics: true,
          constraints: BoxConstraints(maxWidth: components.tooltipMaxWidth),
          padding: EdgeInsets.symmetric(
            horizontal: components.tooltipPaddingH,
            vertical: components.tooltipPaddingV,
          ),
          verticalOffset: minTarget / 2 + components.tooltipOffset,
          decoration: BoxDecoration(
            color: colors.ink,
            borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r8),
          ),
          textStyle: AppTheme.typography.of(context).tooltip.copyWith(color: colors.white),
          child: AppFocusRing(
            borderRadius: BorderRadius.circular(minTarget),
            color: widget.focusRingColor,
            child: Opacity(
              opacity: disabled ? components.disabledOpacity : 1,
              child: IconButton(
                focusNode: _focusNode,
                padding: EdgeInsets.all(AppTheme.dimensions.spacing.s8),
                constraints: BoxConstraints(minWidth: minTarget, minHeight: minTarget),
                iconSize: widget.size,
                mouseCursor: disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
                hoverColor: disabled ? Colors.transparent : null,
                highlightColor: disabled ? Colors.transparent : null,
                splashColor: disabled ? Colors.transparent : null,
                icon: Icon(widget.icon, color: widget.color, size: widget.size),
                onPressed: () {
                  if (!disabled) widget.onPressed();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
