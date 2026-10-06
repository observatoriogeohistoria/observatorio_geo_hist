import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class InlineLink extends StatefulWidget {
  const InlineLink({
    super.key,
    required this.text,
    required this.url,
    this.semanticLabel,
    this.style,
  });

  final String text;
  final String url;
  final String? semanticLabel;
  final TextStyle? style;

  @override
  State<InlineLink> createState() => _InlineLinkState();
}

class _InlineLinkState extends State<InlineLink> {
  bool _hovered = false;

  bool get _sameTab => widget.url.startsWith('mailto:') || widget.url.startsWith('tel:');

  void _open() => openUrl(widget.url, sameTab: _sameTab);

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    // Acento forte: o acento normal fica abaixo de 4,5:1 sobre a superfície.
    final color = _hovered ? colors.ink : colors.accentStrong;
    final style = (widget.style ?? AppTheme.typography.of(context).regular).copyWith(
      color: color,
      decoration: TextDecoration.underline,
      decorationColor: color,
    );
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r6);

    return Semantics(
      link: true,
      label: widget.semanticLabel ?? widget.text,
      linkUrl: Uri.parse(widget.url),
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
            child: Text(widget.text, style: style),
          ),
        ),
      ),
    );
  }
}
