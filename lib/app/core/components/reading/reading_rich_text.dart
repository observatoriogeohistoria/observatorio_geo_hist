import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Texto do editor rico (delta do Quill em JSON) com o estilo da coluna de
/// leitura (spec 012): parágrafos com vão, títulos como subtítulos, listas,
/// citação com barra laranja, links que abrem em outra aba e imagens na
/// largura da coluna, sem recorte. Cores, fundos, fontes e tamanhos do editor
/// são ignorados, para não ferir o contraste nem a escala de texto.
class ReadingRichText extends StatefulWidget {
  const ReadingRichText(this.content, {super.key});

  final String? content;

  /// Delta sem texto nem imagem, ou que não pode ser lido.
  static bool isEmpty(String? content) {
    final ops = _decode(content);
    if (ops == null) return true;
    for (final op in ops) {
      final insert = op['insert'];
      if (insert is String && insert.trim().isNotEmpty) return false;
      if (insert is Map && insert.containsKey(BlockEmbed.imageType)) return false;
    }
    return true;
  }

  static List<Map<String, dynamic>>? _decode(String? content) {
    if (content == null || content.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(content);
      if (decoded is! List) return null;
      return [
        for (final op in decoded)
          if (op is Map) Map<String, dynamic>.from(op),
      ];
    } catch (_) {
      return null;
    }
  }

  @override
  State<ReadingRichText> createState() => _ReadingRichTextState();
}

const _ignoredAttributes = {'color', 'background', 'font', 'size'};

/// Tira as formatações ignoradas, o conteúdo embutido que não é imagem e as
/// linhas vazias seguidas: o vão entre parágrafos já vem do estilo, e as
/// linhas em branco do editor o dobravam.
List<Map<String, dynamic>> _clean(List<Map<String, dynamic>> ops) {
  final result = <Map<String, dynamic>>[];
  var endsWithNewline = true;

  for (final op in ops) {
    final insert = op['insert'];
    if (insert == null) continue;

    final attributes = op['attributes'] is Map
        ? {
            for (final entry in (op['attributes'] as Map).entries)
              if (!_ignoredAttributes.contains(entry.key)) entry.key as String: entry.value,
          }
        : <String, dynamic>{};

    if (insert is String) {
      var text = insert;
      if (attributes.isEmpty) {
        text = text.replaceAll(RegExp(r'\n{2,}'), '\n');
        if (endsWithNewline) text = text.replaceFirst(RegExp(r'^\n+'), '');
        if (text.isEmpty) continue;
      }
      endsWithNewline = text.endsWith('\n');
      result.add({'insert': text, if (attributes.isNotEmpty) 'attributes': attributes});
    } else {
      if (insert is! Map || !insert.containsKey(BlockEmbed.imageType)) continue;
      endsWithNewline = false;
      result.add({'insert': insert, if (attributes.isNotEmpty) 'attributes': attributes});
    }
  }

  if (!endsWithNewline) result.add({'insert': '\n'});
  return result;
}

class _ReadingRichTextState extends State<ReadingRichText> {
  late QuillController _controller;
  final _focusNode = FocusNode(skipTraversal: true);
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = _buildController();
  }

  @override
  void didUpdateWidget(covariant ReadingRichText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.content != widget.content) {
      _controller.dispose();
      _controller = _buildController();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  QuillController _buildController() {
    final ops = ReadingRichText._decode(widget.content);
    Document document;
    try {
      document = ops == null ? Document() : Document.fromDelta(Delta.fromJson(_clean(ops)));
    } catch (_) {
      document = Document();
    }
    return QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (ReadingRichText.isEmpty(widget.content)) return const SizedBox.shrink();

    return QuillEditor(
      controller: _controller,
      focusNode: _focusNode,
      scrollController: _scrollController,
      config: QuillEditorConfig(
        scrollable: false,
        showCursor: false,
        expands: false,
        padding: EdgeInsets.zero,
        customStyles: _styles(context),
        onLaunchUrl: (url) => openUrl(url),
        embedBuilders: const [_ImageEmbedBuilder()],
        unknownEmbedBuilder: const _IgnoredEmbedBuilder(),
      ),
    );
  }

  DefaultStyles _styles(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final reading = styles.reading.copyWith(color: colors.ink, decoration: TextDecoration.none);
    final paragraphGap = components.readingParagraphGap;
    const noSpacing = HorizontalSpacing.zero;

    DefaultTextBlockStyle block(TextStyle style, VerticalSpacing spacing) =>
        DefaultTextBlockStyle(style, noSpacing, spacing, VerticalSpacing.zero, null);

    final paragraph = block(reading, VerticalSpacing(0, paragraphGap));
    final heading = block(
      styles.readingSubtitle.copyWith(color: colors.ink),
      VerticalSpacing(components.readingSubtitleMarginTop - paragraphGap, components.readingSubtitleMarginBottom),
    );
    final minorHeading = block(reading.copyWith(fontWeight: FontWeight.w700), VerticalSpacing(0, paragraphGap));

    return DefaultStyles(
      h1: heading,
      h2: heading,
      h3: heading,
      h4: minorHeading,
      h5: minorHeading,
      h6: minorHeading,
      paragraph: paragraph,
      lineHeightNormal: paragraph,
      lineHeightTight: paragraph,
      lineHeightOneAndHalf: paragraph,
      lineHeightDouble: paragraph,
      link: TextStyle(
        color: colors.accentStrong,
        decoration: TextDecoration.underline,
        decorationColor: colors.accentStrong,
      ),
      lists: DefaultListBlockStyle(
        reading,
        noSpacing,
        VerticalSpacing(0, components.readingBulletListMarginVertical),
        VerticalSpacing(0, components.readingBulletItemGap),
        null,
        null,
        indentWidthBuilder: _indentWidth,
      ),
      quote: DefaultTextBlockStyle(
        styles.readingQuote.copyWith(color: colors.ink),
        noSpacing,
        VerticalSpacing(
          components.readingQuoteMarginVertical - paragraphGap,
          components.readingQuoteMarginVertical,
        ),
        VerticalSpacing(components.readingQuotePaddingVertical, components.readingQuotePaddingVertical),
        BoxDecoration(
          border: Border(left: BorderSide(color: colors.accent, width: components.readingQuoteBar)),
        ),
      ),
      indent: block(reading, VerticalSpacing(0, paragraphGap)),
      align: block(reading, VerticalSpacing.zero),
      leading: block(reading, VerticalSpacing.zero),
    );
  }

  static HorizontalSpacing _indentWidth(
    Block block,
    BuildContext context,
    int count,
    LeadingBlockNumberPointWidth numberPointWidthBuilder,
  ) {
    if (block.style.attributes.containsKey(Attribute.blockQuote.key)) {
      return HorizontalSpacing(AppTheme.dimensions.components.readingQuotePaddingLeft, 0);
    }
    return TextBlockUtils.defaultIndentWidthBuilder(block, context, count, numberPointWidthBuilder);
  }
}

/// Imagem colada no texto: na largura da coluna, sem recorte, com altura
/// máxima; na falha, placeholder 16:10.
class _ImageEmbedBuilder extends EmbedBuilder {
  const _ImageEmbedBuilder();

  @override
  String get key => BlockEmbed.imageType;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final data = embedContext.node.value.data;
    final url = data is String ? data.trim() : '';
    return _ReadingImage(url: url);
  }
}

class _ReadingImage extends StatelessWidget {
  const _ReadingImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r12);

    final Widget image = url.isEmpty
        ? const _ReadingImagePlaceholder()
        : Image.network(
            url,
            width: double.infinity,
            fit: BoxFit.contain,
            semanticLabel: 'Imagem do artigo',
            errorBuilder: (context, error, stackTrace) => const _ReadingImagePlaceholder(),
          );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: components.readingImageMarginVertical),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: components.readingImageMaxHeight),
        child: ClipRRect(borderRadius: radius, child: image),
      ),
    );
  }
}

class _ReadingImagePlaceholder extends StatelessWidget {
  const _ReadingImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;

    return ExcludeSemantics(
      child: AspectRatio(
        aspectRatio: components.readingImagePlaceholderAspect,
        child: ColoredBox(
          color: colors.accentSoft,
          child: Center(
            child: Icon(Icons.image_outlined, size: components.postPlaceholderIcon, color: colors.accent),
          ),
        ),
      ),
    );
  }
}

class _IgnoredEmbedBuilder extends EmbedBuilder {
  const _IgnoredEmbedBuilder();

  @override
  String get key => 'ignorado';

  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) => const SizedBox.shrink();
}
