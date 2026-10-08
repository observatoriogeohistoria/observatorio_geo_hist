import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/form_validators.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class FormTextField extends StatefulWidget {
  const FormTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.focusNode,
    this.validator,
    this.multiline = false,
    this.keyboardType,
    this.autofillHints,
    this.textInputAction,
    this.onSubmitted,
    this.hintText,
    this.obscureText = false,
    this.suffix,
  });

  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FormValidator? validator;

  final bool multiline;

  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  final String? hintText;
  final bool obscureText;

  /// Fica dentro do campo, à direita, como o botão de mostrar a senha.
  final Widget? suffix;

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_handleFocus);
  }

  @override
  void didUpdateWidget(covariant FormTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_handleFocus);
      widget.focusNode.addListener(_handleFocus);
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocus);
    super.dispose();
  }

  void _handleFocus() {
    if (_focused != widget.focusNode.hasFocus) {
      setState(() => _focused = widget.focusNode.hasFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r12);

    return FormField<String>(
      initialValue: widget.controller.text,
      validator: (_) => widget.validator?.call(widget.controller.text),
      builder: (field) {
        final error = field.errorText;
        final hasError = error != null;
        final borderColor = hasError
            ? colors.error
            : _focused
                ? colors.accent
                : colors.fieldBorder;
        final ringColor = hasError ? colors.errorSurface : colors.accentSoft;
        final suffix = widget.suffix;
        final singleLine = widget.obscureText || !widget.multiline;

        final input = Semantics(
          label: widget.label,
          hint: error,
          validationResult:
              hasError ? SemanticsValidationResult.invalid : SemanticsValidationResult.none,
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            onChanged: field.didChange,
            onSubmitted: widget.onSubmitted,
            keyboardType: singleLine ? widget.keyboardType : TextInputType.multiline,
            textInputAction: singleLine ? widget.textInputAction : TextInputAction.newline,
            autofillHints: widget.autofillHints,
            obscureText: widget.obscureText,
            minLines: singleLine ? 1 : components.formMessageMinLines,
            maxLines: singleLine ? 1 : components.formMessageMaxLines,
            style: styles.regular.copyWith(color: colors.ink),
            cursorColor: colors.accent,
            decoration: InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: styles.regular.copyWith(color: colors.inkSecondary),
              contentPadding: EdgeInsets.symmetric(
                horizontal: components.formFieldPaddingH - components.formFieldBorder,
                vertical: components.formFieldPaddingV - components.formFieldBorder,
              ),
            ),
          ),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // O nome do campo vai na semântica do próprio campo; o texto visível fica de fora.
            ExcludeSemantics(
              child: Text(widget.label, style: styles.formLabel.copyWith(color: colors.ink)),
            ),
            SizedBox(height: components.formFieldLabelGap),
            AnimatedContainer(
              duration: MediaQuery.disableAnimationsOf(context)
                  ? Duration.zero
                  : components.menuAnimation,
              constraints: BoxConstraints(minHeight: components.formFieldHeight),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: colors.page,
                borderRadius: radius,
                border: Border.all(color: borderColor, width: components.formFieldBorder),
                boxShadow: [
                  BoxShadow(
                    color: _focused ? ringColor : ringColor.withValues(alpha: 0),
                    spreadRadius: components.formFieldFocusRing,
                  ),
                ],
              ),
              child: suffix == null ? input : Row(children: [Expanded(child: input), suffix]),
            ),
            if (hasError) ...[
              SizedBox(height: components.formFieldLabelGap),
              ExcludeSemantics(
                child: Text(
                  error,
                  maxLines: components.formErrorMaxLines,
                  overflow: TextOverflow.ellipsis,
                  style: styles.formError.copyWith(color: colors.error),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
