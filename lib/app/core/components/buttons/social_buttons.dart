import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_strings.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key, this.onDark = false});

  final bool onDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SocialButton(
            name: 'instagram', label: 'Instagram', url: AppStrings.instagram, onDark: onDark),
        SizedBox(width: AppTheme.dimensions.spacing.s8),
        _SocialButton(
            name: 'facebook', label: 'Facebook', url: AppStrings.facebook, onDark: onDark),
        SizedBox(width: AppTheme.dimensions.spacing.s8),
        _SocialButton(name: 'youtube', label: 'YouTube', url: AppStrings.youtube, onDark: onDark),
      ],
    );
  }
}

class _SocialButton extends StatefulWidget {
  const _SocialButton({
    required this.name,
    required this.label,
    required this.url,
    required this.onDark,
  });

  final String name;
  final String label;
  final String url;
  final bool onDark;

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r10);

    final highlight = widget.onDark ? colors.footerHighlight : colors.accent;
    final iconColor = _hovered ? highlight : (widget.onDark ? colors.footerText : colors.ink);
    final borderColor = _hovered ? highlight : (widget.onDark ? colors.footerLine : colors.line);

    return Tooltip(
      message: widget.label,
      child: Semantics(
        link: true,
        label: '${widget.label}, abre em outra aba',
        linkUrl: Uri.parse(widget.url),
        onTap: () => openUrl(widget.url),
        excludeSemantics: true,
        child: AppFocusRing(
          borderRadius: radius,
          color: widget.onDark ? colors.footerHighlight : null,
          child: InkWell(
            borderRadius: radius,
            onTap: () => openUrl(widget.url),
            onHover: (value) => setState(() => _hovered = value),
            hoverColor: Colors.transparent,
            mouseCursor: SystemMouseCursors.click,
            child: Ink(
              width: AppTheme.dimensions.spacing.s40,
              height: AppTheme.dimensions.spacing.s40,
              decoration: BoxDecoration(
                borderRadius: radius,
                border: Border.all(color: borderColor),
              ),
              child: Center(
                child: SvgPicture.asset(
                  '${AppAssets.icons}/${widget.name}.svg',
                  width: components.navIcon,
                  height: components.navIcon,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SocialPills extends StatelessWidget {
  const SocialPills({super.key});

  @override
  Widget build(BuildContext context) {
    final gap = AppTheme.dimensions.components.socialPillGap;

    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: const [
        _SocialPill(name: 'instagram', label: 'Instagram', url: AppStrings.instagram),
        _SocialPill(name: 'facebook', label: 'Facebook', url: AppStrings.facebook),
        _SocialPill(name: 'youtube', label: 'YouTube', url: AppStrings.youtube),
      ],
    );
  }
}

class _SocialPill extends StatefulWidget {
  const _SocialPill({required this.name, required this.label, required this.url});

  final String name;
  final String label;
  final String url;

  @override
  State<_SocialPill> createState() => _SocialPillState();
}

class _SocialPillState extends State<_SocialPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.pill);
    final color = _hovered ? colors.accentStrong : colors.ink;
    final iconSize = components.socialPillIcon * MediaQuery.textScalerOf(context).scale(1);

    return Semantics(
      link: true,
      label: '${widget.label}, abre em outra aba',
      linkUrl: Uri.parse(widget.url),
      onTap: () => openUrl(widget.url),
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: radius,
            onTap: () => openUrl(widget.url),
            onHover: (value) => setState(() => _hovered = value),
            hoverColor: Colors.transparent,
            mouseCursor: SystemMouseCursors.click,
            child: Ink(
              padding: EdgeInsets.symmetric(
                horizontal: components.socialPillPaddingH,
                vertical: components.socialPillPaddingV,
              ),
              decoration: BoxDecoration(
                color: colors.page,
                borderRadius: radius,
                border: Border.all(color: _hovered ? colors.accent : colors.line),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    '${AppAssets.icons}/${widget.name}.svg',
                    width: iconSize,
                    height: iconSize,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  ),
                  SizedBox(width: components.socialPillGap),
                  Text(widget.label,
                      style: AppTheme.typography.of(context).badge.copyWith(color: color)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
