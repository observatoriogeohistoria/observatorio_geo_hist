import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_strings.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class SocialIcons extends StatelessWidget {
  const SocialIcons({
    required this.post,
    super.key,
  });

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final gap = AppTheme.dimensions.components.shareGap;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Compartilhar',
      child: Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          _ShareButton(post: post, icon: 'facebook', label: 'Compartilhar no Facebook', link: AppStrings.shareOnFacebook),
          _ShareButton(post: post, icon: 'twitter', label: 'Compartilhar no Twitter', link: AppStrings.shareOnX),
          _ShareButton(post: post, icon: 'whatsapp', label: 'Compartilhar no WhatsApp', link: AppStrings.shareOnWhatsapp),
          _ShareButton(
            post: post,
            icon: 'email',
            label: 'Compartilhar por e-mail',
            link: AppStrings.shareOnEmail,
            sameTab: true,
          ),
        ],
      ),
    );
  }
}

class _ShareButton extends StatefulWidget {
  const _ShareButton({
    required this.post,
    required this.icon,
    required this.label,
    required this.link,
    this.sameTab = false,
  });

  final PostModel post;
  final String icon;
  final String label;
  final String link;
  final bool sameTab;

  @override
  State<_ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<_ShareButton> {
  bool _hovered = false;

  void _share() {
    final title = encodeUrlComponent(widget.post.body?.title ?? '');
    final link = widget.link
        .replaceAll('[TEXT]', title)
        .replaceAll('[SUBJECT]', title)
        .replaceAll('[URL]', getEncodedCurrentUrl());
    openUrl(link, sameTab: widget.sameTab);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r10);

    return Tooltip(
      message: widget.label,
      excludeFromSemantics: true,
      child: Semantics(
        button: true,
        label: widget.label,
        onTap: _share,
        excludeSemantics: true,
        child: AppFocusRing(
          borderRadius: radius,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: _share,
              onHover: (value) => setState(() => _hovered = value),
              borderRadius: radius,
              hoverColor: Colors.transparent,
              mouseCursor: SystemMouseCursors.click,
              child: Ink(
                width: components.shareIconButton,
                height: components.shareIconButton,
                decoration: BoxDecoration(
                  color: _hovered ? colors.accentSoft : Colors.transparent,
                  borderRadius: radius,
                ),
                child: Center(
                  child: Image.asset(
                    '${AppAssets.icons}/${widget.icon}.png',
                    width: components.shareIcon,
                    height: components.shareIcon,
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
