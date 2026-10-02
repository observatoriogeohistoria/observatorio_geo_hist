import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/partner.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PartnerLogo extends StatefulWidget {
  const PartnerLogo({super.key, required this.partner});

  final Partner partner;

  @override
  State<PartnerLogo> createState() => _PartnerLogoState();
}

class _PartnerLogoState extends State<PartnerLogo> {
  static const List<double> _identity = [
    1, 0, 0, 0, 0, //
    0, 1, 0, 0, 0, //
    0, 0, 1, 0, 0, //
    0, 0, 0, 1, 0, //
  ];

  // Luminância Rec. 709, o mesmo cinza do `grayscale(1)` do CSS.
  static const List<double> _grayscale = [
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0, 0, 0, 1, 0, //
  ];

  bool _hovered = false;
  bool _focused = false;

  Partner get _partner => widget.partner;

  bool get _active =>
      _hovered ||
      (_focused && FocusManager.instance.highlightMode == FocusHighlightMode.traditional);

  void _open() => openUrl(_partner.url!);

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r14);

    if (_partner.url == null) {
      return Semantics(
        image: true,
        label: _partner.fullName,
        excludeSemantics: true,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: _content(context, radius),
        ),
      );
    }

    return Semantics(
      link: true,
      label: '${_partner.fullName}, abre em outra aba',
      linkUrl: Uri.parse(_partner.url!),
      onTap: _open,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: _open,
            onHover: (value) => setState(() => _hovered = value),
            onFocusChange: (value) => setState(() => _focused = value),
            borderRadius: radius,
            splashFactory: NoSplash.splashFactory,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            mouseCursor: SystemMouseCursors.click,
            child: _content(context, radius),
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, BorderRadius radius) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final active = _active;
    final duration = components.partnerAnimation;
    final shadows = AppTheme.dimensions.shadows;

    final logo = Image.asset(
      _partner.assetPath,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Center(
        child: Text(
          _partner.acronym,
          textAlign: TextAlign.center,
          style: AppTheme.typography.of(context).small.copyWith(color: colors.inkSecondary),
        ),
      ),
    );

    // Tudo sai de um só valor animado para, em repouso, não pintar sombra transparente nem
    // abrir camadas extras de opacidade: os logos ficam em páginas longas e pesavam no scroll.
    return RepaintBoundary(
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: active ? 1 : 0),
        duration: duration,
        child: logo,
        builder: (context, t, logo) => Transform.translate(
          offset: Offset(0, reduceMotion ? 0 : -components.partnerHoverLift * t),
          child: Container(
            constraints: BoxConstraints(minHeight: components.minTapTarget),
            padding: EdgeInsets.all(
              ScreenUtils.breakpointOf(context) == Breakpoint.mobile
                  ? components.partnerPaddingMobile
                  : components.partnerPadding,
            ),
            decoration: t == 0
                ? null
                : BoxDecoration(
                    color: colors.page.withValues(alpha: t),
                    borderRadius: radius,
                    border: Border.all(
                      color: colors.line.withValues(alpha: colors.line.a * t),
                      width: AppTheme.dimensions.stroke.small,
                    ),
                    boxShadow: shadows.fade(shadows.soft, t),
                  ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: components.partnerLogoMaxWidth),
                child: AspectRatio(
                  aspectRatio: components.partnerLogoAspectRatio,
                  child: Transform.scale(
                    scale: reduceMotion ? 1 : lerpDouble(1, components.partnerHoverScale, t)!,
                    child: t == 1
                        ? logo
                        : ColorFiltered(
                            colorFilter: ColorFilter.matrix(
                              _lerpMatrix(t, lerpDouble(components.partnerRestOpacity, 1, t)!),
                            ),
                            child: logo,
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

  // A opacidade vai na própria matriz (linha do alfa) para não abrir mais uma camada.
  List<double> _lerpMatrix(double t, double opacity) {
    return [
      for (var i = 0; i < _identity.length; i++)
        lerpDouble(_grayscale[i], _identity[i], t)! * (i == 18 ? opacity : 1),
    ];
  }
}
