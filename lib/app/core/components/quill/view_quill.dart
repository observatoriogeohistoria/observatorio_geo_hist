import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class ViewQuill extends StatefulWidget {
  const ViewQuill({
    this.initialContent,
    super.key,
  });

  final String? initialContent;

  @override
  State<ViewQuill> createState() => _ViewQuillState();

  static bool isQuillContentEmpty(String? content) {
    if (content == null || content.trim().isEmpty) return true;

    try {
      final List<dynamic> deltaOps = jsonDecode(content);
      for (final op in deltaOps) {
        if (op is Map && op.containsKey('insert')) {
          final value = op['insert'];

          if (value is String && value.trim().isNotEmpty && value.trim() != '\n') {
            return false;
          }

          if (value is! String) return false;
        }
      }
      return true;
    } catch (_) {
      return true;
    }
  }
}

class _ViewQuillState extends State<ViewQuill> {
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

    _controller.readOnly = true;
  }

  @override
  Widget build(BuildContext context) {
    const horizontalSpacing = HorizontalSpacing.zero;
    const verticalSpacing = VerticalSpacing.zero;
    const lineSpacing = VerticalSpacing.zero;

    return QuillEditor.basic(
      controller: _controller,
      config: QuillEditorConfig(
        customStyles: DefaultStyles(
          h1: DefaultTextBlockStyle(
            AppTheme.typography.title.big.copyWith(color: AppTheme.colors.darkGray),
            horizontalSpacing,
            verticalSpacing,
            lineSpacing,
            null,
          ),
          h2: DefaultTextBlockStyle(
            AppTheme.typography.title.medium.copyWith(color: AppTheme.colors.darkGray),
            horizontalSpacing,
            verticalSpacing,
            lineSpacing,
            null,
          ),
          h3: DefaultTextBlockStyle(
            AppTheme.typography.title.small.copyWith(color: AppTheme.colors.darkGray),
            horizontalSpacing,
            verticalSpacing,
            lineSpacing,
            null,
          ),
          h4: DefaultTextBlockStyle(
            AppTheme.typography.body.big.copyWith(color: AppTheme.colors.darkGray),
            horizontalSpacing,
            verticalSpacing,
            lineSpacing,
            null,
          ),
          h5: DefaultTextBlockStyle(
            AppTheme.typography.body.medium.copyWith(color: AppTheme.colors.darkGray),
            horizontalSpacing,
            verticalSpacing,
            lineSpacing,
            null,
          ),
          h6: DefaultTextBlockStyle(
            AppTheme.typography.body.small.copyWith(color: AppTheme.colors.darkGray),
            horizontalSpacing,
            verticalSpacing,
            lineSpacing,
            null,
          ),
          paragraph: DefaultTextBlockStyle(
            AppTheme.typography.body.big.copyWith(color: AppTheme.colors.darkGray),
            horizontalSpacing,
            verticalSpacing,
            lineSpacing,
            null,
          ),
        ),
      ),
    );
  }
}
