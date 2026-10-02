import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/browser/native_share.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_strings.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostShare extends StatefulWidget {
  const PostShare({super.key, required this.post});

  final PostModel post;

  @override
  State<PostShare> createState() => _PostShareState();
}

enum _CopyStatus { idle, copied, failed }

class _ShareOption {
  const _ShareOption(
      {required this.icon, required this.label, required this.link, this.sameTab = false});

  final String icon;
  final String label;
  final String link;
  final bool sameTab;
}

const _networks = [
  _ShareOption(
      icon: 'whatsapp', label: 'Compartilhar no WhatsApp', link: AppStrings.shareOnWhatsapp),
  _ShareOption(
      icon: 'facebook', label: 'Compartilhar no Facebook', link: AppStrings.shareOnFacebook),
  _ShareOption(icon: 'x', label: 'Compartilhar no X', link: AppStrings.shareOnX),
  _ShareOption(
      icon: 'linkedin', label: 'Compartilhar no LinkedIn', link: AppStrings.shareOnLinkedin),
  _ShareOption(
      icon: 'telegram', label: 'Compartilhar no Telegram', link: AppStrings.shareOnTelegram),
  _ShareOption(
      icon: 'email',
      label: 'Compartilhar por e-mail',
      link: AppStrings.shareOnEmail,
      sameTab: true),
];

const _copyText = 'Copiar link';
const _copiedText = 'Link copiado';
const _copyFailedText = 'Erro ao copiar';
const _copyFailedAnnouncement = 'Não foi possível copiar o link';
const _nativeText = 'Compartilhar';
const _nativeLabel = 'Compartilhar pelo aparelho';

class _PostShareState extends State<PostShare> {
  _CopyStatus _copyStatus = _CopyStatus.idle;
  Timer? _copyTimer;

  String get _title => widget.post.body?.title ?? '';

  @override
  void dispose() {
    _copyTimer?.cancel();
    super.dispose();
  }

  void _open(_ShareOption option) {
    final title = encodeUrlComponent(_title);
    final link = option.link
        .replaceAll('[TEXT]', title)
        .replaceAll('[SUBJECT]', title)
        .replaceAll('[URL]', getEncodedCurrentUrl());
    openUrl(link, sameTab: option.sameTab);
  }

  Future<void> _copy() async {
    var status = _CopyStatus.copied;
    try {
      await Clipboard.setData(ClipboardData(text: Uri.base.toString()));
    } catch (_) {
      status = _CopyStatus.failed;
    }
    if (!mounted) return;

    final changed = status != _copyStatus;
    setState(() => _copyStatus = status);
    _copyTimer?.cancel();
    _copyTimer = Timer(AppTheme.dimensions.components.shareFeedbackDuration, () {
      if (mounted) setState(() => _copyStatus = _CopyStatus.idle);
    });
    if (changed) {
      SemanticsService.sendAnnouncement(
        View.of(context),
        status == _CopyStatus.copied ? _copiedText : _copyFailedAnnouncement,
        TextDirection.ltr,
      );
    }
  }

  void _shareNatively() {
    nativeShare(title: _title, url: Uri.base.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ScreenUtils.breakpointOf(context) == Breakpoint.mobile;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Compartilhar',
      child: isMobile ? _buildMobile(context) : _buildWide(context),
    );
  }

  Widget _buildWide(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);

    return Wrap(
      spacing: components.shareGap,
      runSpacing: components.shareRowGap,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ExcludeSemantics(
          child: Padding(
            padding: EdgeInsets.only(right: components.shareLabelGap),
            child: Text(_nativeText.toUpperCase(),
                style: styles.label.copyWith(color: colors.inkSecondary)),
          ),
        ),
        for (final option in _networks)
          _ShareIconButton(label: option.label, asset: option.icon, onTap: () => _open(option)),
        Padding(
          padding: EdgeInsets.only(left: components.shareCopyGap),
          child: _copyButton(),
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final (copyLabel, copyIcon) = switch (_copyStatus) {
      _CopyStatus.idle => (_copyText, Icons.link),
      _CopyStatus.copied => (_copiedText, Icons.check),
      _CopyStatus.failed => (_copyFailedText, Icons.error_outline),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ExcludeSemantics(
          child: Text.rich(
            TextSpan(
              text: _nativeText.toUpperCase(),
              style: styles.label.copyWith(color: colors.inkSecondary),
              children: [
                if (_copyStatus != _CopyStatus.idle)
                  TextSpan(text: '  ·  $copyLabel', style: TextStyle(color: colors.accentStrong)),
              ],
            ),
          ),
        ),
        SizedBox(height: components.shareLabelGap),
        Wrap(
          spacing: components.shareGap,
          runSpacing: components.shareRowGap,
          children: [
            if (canNativeShare())
              _ShareIconButton(label: _nativeLabel, icon: Icons.ios_share, onTap: _shareNatively),
            _ShareIconButton(label: _copyText, icon: copyIcon, onTap: _copy),
            for (final option in _networks)
              _ShareIconButton(label: option.label, asset: option.icon, onTap: () => _open(option)),
          ],
        ),
      ],
    );
  }

  Widget _copyButton() {
    final (text, icon) = switch (_copyStatus) {
      _CopyStatus.idle => (_copyText, Icons.link),
      _CopyStatus.copied => (_copiedText, Icons.check),
      _CopyStatus.failed => (_copyFailedText, Icons.error_outline),
    };

    return Tooltip(
      message: _copyText,
      excludeFromSemantics: true,
      child: SecondaryButton.small(
        text: text,
        leadingIcon: icon,
        reserveTexts: const [_copyText, _copiedText, _copyFailedText],
        onPressed: _copy,
      ),
    );
  }
}

class _ShareIconButton extends StatefulWidget {
  const _ShareIconButton({required this.label, required this.onTap, this.asset, this.icon});

  final String label;
  final VoidCallback onTap;
  final String? asset;
  final IconData? icon;

  @override
  State<_ShareIconButton> createState() => _ShareIconButtonState();
}

class _ShareIconButtonState extends State<_ShareIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r10);
    final color = _hovered ? colors.accentStrong : colors.inkSecondary;

    return Tooltip(
      message: widget.label,
      excludeFromSemantics: true,
      child: Semantics(
        button: true,
        label: widget.label,
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
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              mouseCursor: SystemMouseCursors.click,
              child: Ink(
                width: components.shareIconButton,
                height: components.shareIconButton,
                decoration: BoxDecoration(
                  color: _hovered ? colors.accentSoft : Colors.transparent,
                  borderRadius: radius,
                ),
                child: Center(
                  child: widget.asset != null
                      ? SvgPicture.asset(
                          '${AppAssets.icons}/share_${widget.asset}.svg',
                          width: components.shareIcon,
                          height: components.shareIcon,
                          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                        )
                      : Icon(widget.icon, size: components.shareIcon, color: color),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
