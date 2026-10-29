import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:observatorio_geo_hist/app/core/components/form/form_field_frame.dart';
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
    this.isOptional = false,
    this.helperText,
    this.readOnly = false,
    this.minLines,
    this.maxLines,
    this.inputFormatters,
    this.formFieldKey,
    this.autofocus = false,
    this.style,
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

  /// Sits inside the field, on the right, like the show-password button.
  final Widget? suffix;

  final bool isOptional;
  final String? helperText;
  final bool readOnly;
  final int? minLines;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final GlobalKey<FormFieldState<String>>? formFieldKey;
  final bool autofocus;
  final TextStyle? style;

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
      key: widget.formFieldKey,
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
          label: FormFieldFrame.semanticLabel(widget.label, isOptional: widget.isOptional),
          hint: FormFieldFrame.semanticHint(error: error, helper: widget.helperText),
          validationResult:
              hasError ? SemanticsValidationResult.invalid : SemanticsValidationResult.none,
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            readOnly: widget.readOnly,
            onChanged: field.didChange,
            onSubmitted: widget.onSubmitted,
            keyboardType: singleLine ? widget.keyboardType : TextInputType.multiline,
            textInputAction: singleLine ? widget.textInputAction : TextInputAction.newline,
            autofillHints: widget.autofillHints,
            inputFormatters: widget.inputFormatters,
            obscureText: widget.obscureText,
            minLines: singleLine ? 1 : widget.minLines ?? components.formMessageMinLines,
            maxLines: singleLine ? 1 : widget.maxLines ?? components.formMessageMaxLines,
            style: (widget.style ?? styles.regular).copyWith(color: colors.ink),
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

        return FormFieldFrame(
          label: widget.label,
          isOptional: widget.isOptional,
          helperText: widget.helperText,
          errorText: error,
          child: AnimatedContainer(
            duration:
                MediaQuery.disableAnimationsOf(context) ? Duration.zero : components.menuAnimation,
            constraints: BoxConstraints(minHeight: components.formFieldHeight),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: widget.readOnly ? colors.surface : colors.page,
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
        );
      },
    );
  }
}
