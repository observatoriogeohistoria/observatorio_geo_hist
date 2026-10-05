import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_text_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/inline_link.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/form/marked_text.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/mail_draft.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class MailConfirmationTexts {
  const MailConfirmationTexts({
    this.title = 'Seu e-mail está pronto',
    this.message =
        'Abrimos o seu programa de e-mail com a mensagem preenchida. Aperte **Enviar** por lá para concluir.',
    this.fallback = 'Não abriu? Copie a mensagem e escreva para',
    this.copy = 'Copiar mensagem',
    this.copied = 'Mensagem copiada',
    this.copyFailed = 'Erro ao copiar',
    this.copyFailedAnnouncement = 'Não foi possível copiar a mensagem',
    this.back = 'Voltar ao formulário',
  });

  final String title;
  final String message;
  final String fallback;
  final String copy;
  final String copied;
  final String copyFailed;
  final String copyFailedAnnouncement;
  final String back;
}

enum _CopyStatus { idle, copied, failed }

class MailConfirmation extends StatefulWidget {
  const MailConfirmation({
    super.key,
    required this.draft,
    required this.onBack,
    this.texts = const MailConfirmationTexts(),
  });

  final MailDraft draft;
  final VoidCallback onBack;
  final MailConfirmationTexts texts;

  @override
  State<MailConfirmation> createState() => _MailConfirmationState();
}

class _MailConfirmationState extends State<MailConfirmation> {
  final _titleFocus = FocusNode(skipTraversal: true);
  _CopyStatus _copyStatus = _CopyStatus.idle;
  Timer? _copyTimer;

  @override
  void initState() {
    super.initState();
    // O botão que abriu a confirmação sumiu; sem isso o foco do teclado ficaria perdido.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _titleFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _copyTimer?.cancel();
    _titleFocus.dispose();
    super.dispose();
  }

  Future<void> _copy() async {
    var status = _CopyStatus.copied;
    try {
      await Clipboard.setData(ClipboardData(text: widget.draft.copyText));
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
        status == _CopyStatus.copied ? widget.texts.copied : widget.texts.copyFailedAnnouncement,
        TextDirection.ltr,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final texts = widget.texts;
    final textStyle = styles.regular.copyWith(color: colors.inkSecondary);
    final (copyText, copyIcon) = switch (_copyStatus) {
      _CopyStatus.idle => (texts.copy, Icons.link),
      _CopyStatus.copied => (texts.copied, Icons.check),
      _CopyStatus.failed => (texts.copyFailed, Icons.error_outline),
    };

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r18),
        border: Border.all(color: colors.line, width: AppTheme.dimensions.stroke.small),
      ),
      padding: EdgeInsets.symmetric(
        vertical: components.mailConfirmationPaddingV,
        horizontal: components.mailConfirmationPaddingH,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(
            child: Container(
              width: components.mailConfirmationIcon,
              height: components.mailConfirmationIcon,
              decoration: BoxDecoration(color: colors.successSurface, shape: BoxShape.circle),
              child: Icon(
                Icons.mail_outline,
                size: components.mailConfirmationIconGlyph,
                color: colors.success,
              ),
            ),
          ),
          SizedBox(height: components.mailConfirmationGap),
          Focus(
            focusNode: _titleFocus,
            child: Semantics(
              header: true,
              liveRegion: true,
              child: Text(
                texts.title,
                textAlign: TextAlign.center,
                style: styles.confirmationTitle.copyWith(color: colors.ink),
              ),
            ),
          ),
          SizedBox(height: components.mailConfirmationGap),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: components.mailConfirmationTextMaxWidth),
            child: Column(
              children: [
                MarkedText(texts.message, style: textStyle, textAlign: TextAlign.center),
                SizedBox(height: components.mailConfirmationGap),
                Text.rich(
                  TextSpan(
                    style: styles.meta.copyWith(color: colors.inkSecondary),
                    children: [
                      TextSpan(text: '${texts.fallback} '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: InlineLink(
                          text: widget.draft.to,
                          url: 'mailto:${widget.draft.to}',
                          style: styles.meta,
                        ),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: components.mailConfirmationGap + components.mailConfirmationButtonsTop),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: components.mailConfirmationButtonsGap,
            runSpacing: components.mailConfirmationButtonsGap,
            children: [
              SecondaryButton.medium(
                text: copyText,
                leadingIcon: copyIcon,
                reserveTexts: [texts.copy, texts.copied, texts.copyFailed],
                onPressed: _copy,
              ),
              AppTextButton.medium(text: texts.back, onPressed: widget.onBack),
            ],
          ),
        ],
      ),
    );
  }
}
