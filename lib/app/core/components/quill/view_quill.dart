import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

class ViewQuill extends StatefulWidget {
  const ViewQuill({
    this.initialContent,
    super.key,
  });

  final String? initialContent;

  @override
  State<ViewQuill> createState() => _ViewQuillState();
}

class _ViewQuillState extends State<ViewQuill> {
  late QuillController _controller;

  @override
  void initState() {
    super.initState();

    _controller = QuillController(
      document: widget.initialContent != null
          ? Document.fromDelta(Delta.fromJson(jsonDecode(widget.initialContent!)))
          : Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );

    _controller.readOnly = true;
  }

  @override
  Widget build(BuildContext context) {
    return QuillEditor.basic(
      controller: _controller,
      config: const QuillEditorConfig(),
    );
  }
}
