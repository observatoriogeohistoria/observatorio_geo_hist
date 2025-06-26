import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
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
  }

  String _saveContent() => jsonEncode(_controller.document.toDelta().toJson());

  @override
  Widget build(BuildContext context) {
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
          padding: EdgeInsets.all(AppTheme.dimensions.space.small.scale),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.medium),
            border: Border.all(
              width: AppTheme.dimensions.stroke.small.scale,
              color: AppTheme.colors.gray,
            ),
          ),
          child: QuillEditor.basic(
            controller: _controller,
          ),
        ),
      ],
    );
  }
}
