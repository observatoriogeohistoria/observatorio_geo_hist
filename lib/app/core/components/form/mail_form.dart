import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/form/form_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/form/mail_confirmation.dart';
import 'package:observatorio_geo_hist/app/core/components/form/marked_text.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/mail_draft.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/form_validators.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class MailFormFieldSpec {
  const MailFormFieldSpec({
    required this.label,
    this.validator,
    this.multiline = false,
    this.keyboardType,
    this.autofillHints,
  });

  final String label;
  final FormValidator? validator;
  final bool multiline;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
}

class MailForm extends StatefulWidget {
  const MailForm({
    super.key,
    required this.fields,
    required this.submitText,
    required this.hint,
    required this.buildDraft,
    this.confirmationTexts = const MailConfirmationTexts(),
  });

  final List<MailFormFieldSpec> fields;
  final String submitText;

  /// Aceita `**negrito**`.
  final String hint;

  /// Recebe os valores já aparados, na ordem de [fields].
  final MailDraft Function(List<String> values) buildDraft;

  final MailConfirmationTexts confirmationTexts;

  @override
  State<MailForm> createState() => _MailFormState();
}

class _MailFormState extends State<MailForm> {
  final _formKey = GlobalKey<FormState>();
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  late final List<GlobalKey> _fieldKeys;

  bool _attempted = false;
  MailDraft? _draft;

  @override
  void initState() {
    super.initState();
    _controllers = [for (final _ in widget.fields) TextEditingController()];
    _focusNodes = [for (final _ in widget.fields) FocusNode()];
    _fieldKeys = [for (final _ in widget.fields) GlobalKey()];
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _submit() {
    setState(() => _attempted = true);
    if (!_formKey.currentState!.validate()) {
      for (final (index, field) in widget.fields.indexed) {
        if (field.validator?.call(_controllers[index].text) != null) {
          _focusField(index);
          break;
        }
      }
      return;
    }

    final draft = widget.buildDraft([for (final c in _controllers) c.text.trim()]);
    setState(() => _draft = draft);
    openUrl(draft.mailtoUrl, sameTab: true);
  }

  void _back() {
    setState(() {
      _draft = null;
      _attempted = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusField(0);
    });
  }

  // O foco direto não rola a página: o campo ficaria acima da tela ou sob a navbar fixa.
  void _focusField(int index) {
    _focusNodes[index].requestFocus();
    final fieldContext = _fieldKeys[index].currentContext;
    if (fieldContext != null) {
      Scrollable.ensureVisible(
        fieldContext,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = _draft;
    if (draft != null) {
      return MailConfirmation(draft: draft, onBack: _back, texts: widget.confirmationTexts);
    }

    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final isMobile = ScreenUtils.breakpointOf(context) == Breakpoint.mobile;
    final fields = widget.fields;

    return Form(
      key: _formKey,
      // Só depois da primeira tentativa; `onUserInteraction` deixaria de fora os campos ainda não tocados.
      autovalidateMode: _attempted ? AutovalidateMode.always : AutovalidateMode.disabled,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (index, field) in fields.indexed) ...[
              FormTextField(
                key: _fieldKeys[index],
                label: field.label,
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                validator: field.validator,
                multiline: field.multiline,
                keyboardType: field.keyboardType,
                autofillHints: field.autofillHints,
                textInputAction:
                    index < fields.length - 1 ? TextInputAction.next : TextInputAction.done,
                onSubmitted:
                    index < fields.length - 1 ? (_) => _focusNodes[index + 1].requestFocus() : null,
              ),
              SizedBox(height: components.formFieldGap),
            ],
            Align(
              alignment: Alignment.centerLeft,
              child: PrimaryButton.medium(
                text: widget.submitText,
                leadingIcon: Icons.mail_outline,
                expand: isMobile,
                onPressed: _submit,
              ),
            ),
            SizedBox(height: components.formHintTop),
            Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: components.formHintMaxWidth),
                child: MarkedText(
                  widget.hint,
                  style: styles.small.copyWith(color: colors.inkSecondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
