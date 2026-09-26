import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

enum ButtonSize { small, medium, big }

/// Tipo visual do botão: primário, secundário ou discreto.
enum AppButtonKind { primary, secondary, ghost }

/// Base dos botões do site. `PrimaryButton`, `SecondaryButton` e
/// `AppTextButton` só escolhem o [kind] e o [size].
class AppButtonBase extends StatefulWidget {
  const AppButtonBase({
    super.key,
    required this.kind,
    required this.size,
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
    this.trailingIcon,
  });

  final AppButtonKind kind;
  final ButtonSize size;
  final String text;
  final VoidCallback onPressed;
  final bool isDisabled;

  /// Ícone opcional depois do texto (por exemplo, uma seta). É decorativo:
  /// o leitor de tela lê só o [text].
  final IconData? trailingIcon;

  @override
  State<AppButtonBase> createState() => _AppButtonBaseState();
}

class _AppButtonBaseState extends State<AppButtonBase> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r10);
    final hovered = _hovered && !widget.isDisabled;

    final (background, foreground, border) = switch (widget.kind) {
      AppButtonKind.primary => (hovered ? colors.accentStrong : colors.accent, colors.white, Colors.transparent),
      AppButtonKind.secondary => (hovered ? colors.ink : Colors.transparent, hovered ? colors.white : colors.ink, colors.ink),
      // Acento forte também em repouso: o botão pode cair sobre a superfície `#F7F5F2`,
      // onde o acento normal fica abaixo de 4,5:1.
      AppButtonKind.ghost => (hovered ? colors.accentSoft : Colors.transparent, colors.accentStrong, Colors.transparent),
    };

    final (fontSize, minHeight, horizontal, vertical) = switch (widget.size) {
      ButtonSize.small => (components.buttonTextSmall, components.buttonMinHeightSmall, spacing.s16, spacing.s8),
      ButtonSize.medium => (components.buttonTextMedium, components.buttonMinHeightRegular, spacing.s20, spacing.s12),
      ButtonSize.big => (components.buttonTextBig, components.buttonMinHeightRegular, spacing.s24, spacing.s12),
    };

    final textStyle = AppTheme.typography.of(context).regular.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          height: 1.3,
          color: foreground,
        );

    return Semantics(
      button: true,
      enabled: !widget.isDisabled,
      label: widget.text,
      // Repete a ação do InkWell (excluído da semântica) para o leitor de tela ativar o botão.
      onTap: widget.isDisabled ? null : widget.onPressed,
      excludeSemantics: true,
      child: Opacity(
        opacity: widget.isDisabled ? 0.5 : 1,
        child: AppFocusRing(
          borderRadius: radius,
          child: Material(
            color: background,
            shape: RoundedRectangleBorder(
              borderRadius: radius,
              side: BorderSide(color: border, width: AppTheme.dimensions.stroke.medium),
            ),
            child: InkWell(
              customBorder: RoundedRectangleBorder(borderRadius: radius),
              onTap: widget.isDisabled ? null : widget.onPressed,
              onHover: (value) => setState(() => _hovered = value),
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              mouseCursor: widget.isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
                  child: Center(
                    widthFactor: 1,
                    heightFactor: 1,
                    child: SelectionContainer.disabled(
                      child: widget.trailingIcon == null
                          ? Text(widget.text, textAlign: TextAlign.center, style: textStyle)
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(child: Text(widget.text, textAlign: TextAlign.center, style: textStyle)),
                                SizedBox(width: spacing.s8),
                                Icon(
                                  widget.trailingIcon,
                                  size: fontSize * components.buttonIconScale,
                                  color: foreground,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
