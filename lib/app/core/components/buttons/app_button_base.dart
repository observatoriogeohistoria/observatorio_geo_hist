import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

enum ButtonSize { small, medium, big }

enum AppButtonKind { primary, secondary, ghost }

class AppButtonBase extends StatefulWidget {
  const AppButtonBase({
    super.key,
    required this.kind,
    required this.size,
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
    this.trailingIcon,
    this.leadingIcon,
    this.reserveTexts = const [],
    this.expand = false,
    this.isLoading = false,
  });

  final AppButtonKind kind;
  final ButtonSize size;
  final String text;
  final VoidCallback onPressed;
  final bool isDisabled;

  final IconData? trailingIcon;

  final IconData? leadingIcon;

  /// Textos que podem substituir [text]. O botão fica com a largura do maior, para não pular na troca.
  final List<String> reserveTexts;

  /// Ocupa a largura disponível, como no botão principal em tela estreita.
  final bool expand;

  /// Mostra o indicador antes do texto e ignora cliques, mas com opacidade cheia, para manter o contraste.
  final bool isLoading;

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
    final inactive = widget.isDisabled || widget.isLoading;
    final hovered = _hovered && !inactive;

    final (background, foreground, border) = switch (widget.kind) {
      AppButtonKind.primary => (
          hovered ? colors.accentStrong : colors.accent,
          colors.white,
          Colors.transparent
        ),
      AppButtonKind.secondary => (
          hovered ? colors.ink : Colors.transparent,
          hovered ? colors.white : colors.ink,
          colors.ink
        ),
      // Laranja forte também em repouso: sobre a superfície clara, o laranja normal fica abaixo de 4,5:1.
      AppButtonKind.ghost => (
          hovered ? colors.accentSoft : Colors.transparent,
          colors.accentStrong,
          Colors.transparent
        ),
    };

    final (fontSize, minHeight, horizontal, vertical) = switch (widget.size) {
      ButtonSize.small => (
          components.buttonTextSmall,
          components.buttonMinHeightSmall,
          spacing.s16,
          spacing.s8
        ),
      ButtonSize.medium => (
          components.buttonTextMedium,
          components.buttonMinHeightRegular,
          spacing.s20,
          spacing.s12
        ),
      ButtonSize.big => (
          components.buttonTextBig,
          components.buttonMinHeightRegular,
          spacing.s24,
          spacing.s12
        ),
    };

    final textStyle = AppTheme.typography.of(context).regular.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          height: 1.3,
          color: foreground,
        );

    final iconSize = fontSize * components.buttonIconScale;

    final Widget? leading = widget.isLoading
        ? SizedBox.square(
            dimension: components.buttonSpinnerSize,
            child: CircularProgressIndicator(
              value: MediaQuery.disableAnimationsOf(context)
                  ? components.buttonSpinnerStaticValue
                  : null,
              strokeWidth: components.buttonSpinnerStroke,
              color: foreground,
              backgroundColor: foreground.withValues(alpha: components.buttonSpinnerTrackOpacity),
            ),
          )
        : widget.leadingIcon == null
            ? null
            : Icon(widget.leadingIcon, size: iconSize, color: foreground);

    Widget content(String text) {
      final label = Text(text, textAlign: TextAlign.center, style: textStyle);
      if (widget.trailingIcon == null && leading == null) return label;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            leading,
            SizedBox(width: spacing.s8),
          ],
          Flexible(child: label),
          if (widget.trailingIcon != null) ...[
            SizedBox(width: spacing.s8),
            Icon(widget.trailingIcon, size: iconSize, color: foreground),
          ],
        ],
      );
    }

    final child = widget.reserveTexts.isEmpty
        ? content(widget.text)
        : Stack(
            alignment: Alignment.center,
            children: [
              for (final reserved in widget.reserveTexts)
                Visibility(
                  visible: false,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: content(reserved),
                ),
              content(widget.text),
            ],
          );

    return Semantics(
      button: true,
      enabled: !inactive,
      label: widget.text,
      onTap: inactive ? null : widget.onPressed,
      excludeSemantics: true,
      child: Opacity(
        opacity: widget.isDisabled ? 0.5 : 1,
        child: AppFocusRing(
          borderRadius: radius,
          fit: widget.expand ? StackFit.passthrough : StackFit.loose,
          child: Material(
            color: background,
            shape: RoundedRectangleBorder(
              borderRadius: radius,
              side: BorderSide(color: border, width: AppTheme.dimensions.stroke.medium),
            ),
            child: InkWell(
              customBorder: RoundedRectangleBorder(borderRadius: radius),
              onTap: inactive ? null : widget.onPressed,
              onHover: (value) => setState(() => _hovered = value),
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              mouseCursor: widget.isDisabled
                  ? SystemMouseCursors.forbidden
                  : widget.isLoading
                      ? SystemMouseCursors.wait
                      : SystemMouseCursors.click,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
                  child: Center(
                    widthFactor: widget.expand ? null : 1,
                    heightFactor: 1,
                    child: SelectionContainer.disabled(
                      child: child,
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
