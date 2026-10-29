import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:observatorio_geo_hist/app/core/components/form/form_field_frame.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class EditorQuill extends StatefulWidget {
  const EditorQuill({
    required this.controller,
    required this.label,
    this.focusNode,
    this.errorText,
    this.helperText,
    this.isOptional = false,
    this.placeholder,
    this.minHeight,
    this.onChanged,
    super.key,
  });

  final QuillController controller;
  final String label;
  final FocusNode? focusNode;
  final String? errorText;
  final String? helperText;
  final bool isOptional;
  final String? placeholder;
  final double? minHeight;
  final VoidCallback? onChanged;

  static QuillController controllerFor(String? json) {
    return QuillController(
      document: (json?.isNotEmpty ?? false)
          ? Document.fromDelta(Delta.fromJson(jsonDecode(json!)))
          : Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  static String toJson(QuillController controller) =>
      jsonEncode(controller.document.toDelta().toJson());

  /// The document always has at least one line break; empty means no visible text.
  static bool isEmpty(QuillController controller) =>
      controller.document.toPlainText().trim().isEmpty;

  @override
  State<EditorQuill> createState() => _EditorQuillState();
}

class _EditorQuillState extends State<EditorQuill> {
  FocusNode? _ownFocus;
  StreamSubscription<DocChange>? _changes;
  bool _focused = false;

  FocusNode get _focusNode => widget.focusNode ?? (_ownFocus ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _listen();
  }

  @override
  void didUpdateWidget(covariant EditorQuill oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) _listen();
  }

  void _listen() {
    _changes?.cancel();
    _changes = widget.controller.document.changes.listen((_) => widget.onChanged?.call());
  }

  @override
  void dispose() {
    _changes?.cancel();
    _ownFocus?.dispose();
    super.dispose();
  }

  // Quill's Tab indents and traps focus; here it follows the page order. List indenting
  // is still available in the toolbar buttons.
  KeyEventResult? _handleKey(KeyEvent event, Node? _) {
    if (event.logicalKey != LogicalKeyboardKey.tab) return null;
    if (event is! KeyUpEvent) {
      HardwareKeyboard.instance.isShiftPressed
          ? _focusNode.previousFocus()
          : _focusNode.nextFocus();
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final radius = AppTheme.dimensions.radii.r12;
    final error = widget.errorText;
    final hasError = error != null;
    final borderColor = hasError
        ? colors.error
        : _focused
            ? colors.accent
            : colors.fieldBorder;
    final ringColor = hasError ? colors.errorSurface : colors.accentSoft;

    return FormFieldFrame(
      label: widget.label,
      isOptional: widget.isOptional,
      helperText: widget.helperText,
      errorText: error,
      child: Focus(
        canRequestFocus: false,
        skipTraversal: true,
        onFocusChange: (focused) => setState(() => _focused = focused),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.page,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: _focused ? ringColor : ringColor.withValues(alpha: 0),
                spreadRadius: components.formFieldFocusRing,
              ),
            ],
          ),
          // The border goes in front, so the toolbar background doesn't cover it.
          child: DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: borderColor, width: components.formFieldBorder),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius - components.formFieldBorder),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _toolbar(),
                  Divider(
                    height: AppTheme.dimensions.stroke.small,
                    thickness: AppTheme.dimensions.stroke.small,
                    color: colors.line,
                  ),
                  Semantics(
                    container: true,
                    label:
                        FormFieldFrame.semanticLabel(widget.label, isOptional: widget.isOptional),
                    hint: FormFieldFrame.semanticHint(error: error, helper: widget.helperText),
                    // The editor has its own selection; the page's selection area would fight over dragging.
                    child: SelectionContainer.disabled(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: widget.minHeight ?? 0),
                        child: QuillEditor.basic(
                          controller: widget.controller,
                          focusNode: _focusNode,
                          config: QuillEditorConfig(
                            scrollable: false,
                            expands: false,
                            placeholder: widget.placeholder,
                            padding: EdgeInsets.symmetric(
                              horizontal: components.richTextPaddingH,
                              vertical: components.richTextPaddingV,
                            ),
                            // ignore: experimental_member_use
                            onKeyPressed: _handleKey,
                            customStyles: DefaultStyles(
                              placeHolder: DefaultTextBlockStyle(
                                styles.regular.copyWith(color: colors.inkSecondary),
                                HorizontalSpacing.zero,
                                VerticalSpacing.zero,
                                VerticalSpacing.zero,
                                null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _toolbar() {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final size = components.richTextButtonSize;

    ButtonStyle style({required bool selected}) => ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(selected ? colors.accentSoft : null),
          foregroundColor: WidgetStatePropertyAll(selected ? colors.accentStrong : colors.ink),
          overlayColor: WidgetStatePropertyAll(colors.line),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r8)),
          ),
          side: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.focused)
                ? BorderSide(color: colors.accent, width: AppTheme.dimensions.stroke.medium)
                : BorderSide.none,
          ),
        );

    IconButtonData data({required bool selected}) => IconButtonData(
          iconSize: components.richTextIcon,
          constraints: BoxConstraints.tightFor(width: size, height: size),
          padding: EdgeInsets.zero,
          style: style(selected: selected),
          color: selected ? colors.accentStrong : colors.ink,
        );

    // Without their own nodes, each button's tooltip (its name) would bubble up to the group.
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Formatação do texto',
      child: FocusTraversalGroup(
        child: ColoredBox(
          color: colors.surface,
          child: Padding(
            padding: EdgeInsets.all(components.richTextToolbarPadding),
            child: QuillSimpleToolbar(
              controller: widget.controller,
              config: QuillSimpleToolbarConfig(
                showDividers: true,
                sectionDividerColor: colors.line,
                toolbarIconAlignment: WrapAlignment.start,
                toolbarSectionSpacing: components.richTextButtonGap,
                showBackgroundColorButton: false,
                showAlignmentButtons: true,
                showCodeBlock: false,
                showSearchButton: false,
                showSubscript: false,
                showSuperscript: false,
                iconTheme: QuillIconTheme(
                  iconButtonUnselectedData: data(selected: false),
                  iconButtonSelectedData: data(selected: true),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
