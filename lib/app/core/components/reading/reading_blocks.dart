import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

// Cada bloco traz a própria margem. Lista e destaque somam acima só o que falta,
// para não dobrar o vão que o parágrafo anterior já deixou.

class ReadingLead extends StatelessWidget {
  const ReadingLead(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppTheme.dimensions.components.readingParagraphGap),
      child: Text(text,
          style: AppTheme.typography.of(context).lead.copyWith(color: AppTheme.colors.ink)),
    );
  }
}

class ReadingParagraph extends StatelessWidget {
  const ReadingParagraph(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppTheme.dimensions.components.readingParagraphGap),
      child: Text(text,
          style: AppTheme.typography.of(context).reading.copyWith(color: AppTheme.colors.ink)),
    );
  }
}

class ReadingPlainText extends StatelessWidget {
  const ReadingPlainText(this.text, {super.key});

  final String text;

  static bool isEmpty(String text) => text.trim().isEmpty;

  @override
  Widget build(BuildContext context) {
    final paragraphs = [
      for (final line in text.split(RegExp(r'\r?\n')))
        if (line.trim().isNotEmpty) line.trim(),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [for (final paragraph in paragraphs) ReadingParagraph(paragraph)],
    );
  }
}

class ReadingSubtitle extends StatelessWidget {
  const ReadingSubtitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;

    return Padding(
      padding: EdgeInsets.only(
        top: components.readingSubtitleMarginTop - components.readingParagraphGap,
        bottom: components.readingSubtitleMarginBottom,
      ),
      child: Semantics(
        header: true,
        headingLevel: 2,
        child: Text(text,
            style: AppTheme.typography
                .of(context)
                .readingSubtitle
                .copyWith(color: AppTheme.colors.ink)),
      ),
    );
  }
}

class ReadingBulletList extends StatelessWidget {
  const ReadingBulletList({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;

    return Padding(
      padding: EdgeInsets.only(
        top: math.max(
            0, components.readingBulletListMarginVertical - components.readingParagraphGap),
        bottom: components.readingBulletListMarginVertical,
      ),
      child: Semantics(
        role: SemanticsRole.list,
        explicitChildNodes: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, item) in items.indexed) ...[
              if (index > 0) SizedBox(height: components.readingBulletItemGap),
              _BulletItem(text: item),
            ],
          ],
        ),
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  const _BulletItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final style = AppTheme.typography.of(context).reading.copyWith(color: colors.ink);
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final dot = components.readingBulletDot * scale;
    final lineHeight = style.fontSize! * style.height! * scale;

    return Semantics(
      role: SemanticsRole.listItem,
      label: text,
      excludeSemantics: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: components.readingBulletIndent * scale,
            child: Padding(
              padding: EdgeInsets.only(top: (lineHeight - dot) / 2),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: dot,
                  height: dot,
                  decoration: BoxDecoration(color: colors.ink, shape: BoxShape.circle),
                ),
              ),
            ),
          ),
          Expanded(child: Text(text, style: style)),
        ],
      ),
    );
  }
}

class ReadingNumberedList extends StatelessWidget {
  const ReadingNumberedList({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;

    return Padding(
      padding: EdgeInsets.only(
        top: components.readingListMarginVertical - components.readingParagraphGap,
        bottom: components.readingListMarginVertical,
      ),
      child: Semantics(
        role: SemanticsRole.list,
        explicitChildNodes: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, item) in items.indexed) ...[
              if (index > 0) SizedBox(height: components.readingListItemGap),
              _NumberedItem(number: index + 1, text: item),
            ],
          ],
        ),
      ),
    );
  }
}

class _NumberedItem extends StatelessWidget {
  const _NumberedItem({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final diameter = components.readingListNumberDiameter * scale;

    return Semantics(
      role: SemanticsRole.listItem,
      label: '$number. $text',
      excludeSemantics: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: components.readingListNumberColumn * scale,
            child: Padding(
              padding: EdgeInsets.only(top: components.readingListNumberTopOffset * scale),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: diameter,
                  height: diameter,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: colors.accentSoft, shape: BoxShape.circle),
                  child: Text('$number',
                      style: styles.readingListNumber.copyWith(color: colors.accentStrong)),
                ),
              ),
            ),
          ),
          SizedBox(width: components.readingListNumberGap),
          Expanded(child: Text(text, style: styles.readingListItem.copyWith(color: colors.ink))),
        ],
      ),
    );
  }
}

class ReadingQuote extends StatelessWidget {
  const ReadingQuote(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;

    return Padding(
      padding: EdgeInsets.only(
        top: components.readingQuoteMarginVertical - components.readingParagraphGap,
        bottom: components.readingQuoteMarginVertical,
      ),
      child: Container(
        padding: EdgeInsets.only(
          left: components.readingQuotePaddingLeft,
          top: components.readingQuotePaddingVertical,
          bottom: components.readingQuotePaddingVertical,
        ),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: colors.accent, width: components.readingQuoteBar)),
        ),
        child: Text(text,
            style: AppTheme.typography.of(context).readingQuote.copyWith(color: colors.ink)),
      ),
    );
  }
}
