import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/inline_link.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class CopyButton extends StatefulWidget {
  const CopyButton({
    super.key,
    required this.value,
    required this.subject,
    this.onDark = false,
  });

  final String value;

  /// What gets copied, in lowercase ("e-mail", "telefone"): used in the tooltip and the notice.
  final String subject;

  final bool onDark;

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

enum _CopyStatus { idle, copied, failed }

class _CopyButtonState extends State<CopyButton> {
  _CopyStatus _status = _CopyStatus.idle;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _copy() async {
    var status = _CopyStatus.copied;
    try {
      await Clipboard.setData(ClipboardData(text: widget.value));
    } catch (_) {
      status = _CopyStatus.failed;
    }
    if (!mounted) return;

    setState(() => _status = status);
    _timer?.cancel();
    _timer = Timer(AppTheme.dimensions.components.shareFeedbackDuration, () {
      if (mounted) setState(() => _status = _CopyStatus.idle);
    });
    SemanticsService.sendAnnouncement(
      View.of(context),
      status == _CopyStatus.copied
          ? '${_capitalized(widget.subject)} copiado'
          : 'Não foi possível copiar o ${widget.subject}',
      TextDirection.ltr,
    );
  }

  static String _capitalized(String text) =>
      text.isEmpty ? text : '${text[0].toUpperCase()}${text.substring(1)}';

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final (icon, tooltip) = switch (_status) {
      _CopyStatus.idle => (Icons.content_copy, 'Copiar ${widget.subject}'),
      _CopyStatus.copied => (Icons.check, '${_capitalized(widget.subject)} copiado'),
      _CopyStatus.failed => (Icons.error_outline, 'Não foi possível copiar'),
    };

    return AppIconButton(
      icon: icon,
      tooltip: tooltip,
      label: 'Copiar ${widget.subject} ${widget.value}',
      size: AppTheme.dimensions.components.copyButtonIcon,
      color: widget.onDark ? colors.footerText : colors.inkSecondary,
      focusRingColor: widget.onDark ? colors.footerHighlight : null,
      onPressed: _copy,
    );
  }
}

class CopyableInlineLink extends StatelessWidget {
  const CopyableInlineLink({
    super.key,
    required this.text,
    required this.url,
    required this.subject,
    this.semanticLabel,
  });

  final String text;
  final String url;
  final String subject;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: InlineLink(text: text, url: url, semanticLabel: semanticLabel)),
        SizedBox(width: AppTheme.dimensions.components.copyButtonGap),
        CopyButton(value: text, subject: subject),
      ],
    );
  }
}
