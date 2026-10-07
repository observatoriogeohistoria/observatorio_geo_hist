import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class EditorQuill extends StatefulWidget {
  const EditorQuill({
    required this.saveController,
    this.initialContent,
    required this.height,
    super.key,
  });

  final StreamController<Completer<String>> saveController;
  final String? initialContent;
  final double height;

  @override
  State<EditorQuill> createState() => _EditorQuillState();
}

class _EditorQuillState extends State<EditorQuill> {
  late QuillController _controller;
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();

    _controller = QuillController(
      document: (widget.initialContent?.isNotEmpty ?? false)
          ? Document.fromDelta(Delta.fromJson(jsonDecode(widget.initialContent!)))
          : Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );

    widget.saveController.stream.listen((event) {
      final content = _saveContent();
      event.complete(content);
    });

    _focusNode.addListener(_handleFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocus);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocus() {
    if (_focused != _focusNode.hasFocus) setState(() => _focused = _focusNode.hasFocus);
  }

  String _saveContent() => jsonEncode(_controller.document.toDelta().toJson());

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;

    return Column(
      children: [
        QuillSimpleToolbar(
          controller: _controller,
          config: const QuillSimpleToolbarConfig(
            showDividers: false,
            showBackgroundColorButton: false,
            showAlignmentButtons: true,
            showCodeBlock: false,
            showSearchButton: false,
            showSubscript: false,
            showSuperscript: false,
          ),
        ),
        Container(
          height: widget.height,
          padding: EdgeInsets.all(components.formFieldPaddingH),
          decoration: BoxDecoration(
            color: colors.page,
            borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r10),
            border: Border.all(
              width: _focused ? components.panelFieldFocusedBorder : components.formFieldBorder,
              color: _focused ? colors.accent : colors.fieldBorder,
            ),
          ),
          child: QuillEditor.basic(
            controller: _controller,
            focusNode: _focusNode,
          ),
        ),
      ],
    );
  }
}
