import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

// Blocos da coluna de leitura. Cada um traz a própria margem, para a página só
// empilhar: parágrafos têm vão abaixo; lista e destaque somam acima só o que
// falta para a margem do protótipo, como as margens colapsadas do CSS.

/// Parágrafo de abertura, maior que o texto (`.prose .lead`).
class ReadingLead extends StatelessWidget {
  const ReadingLead(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppTheme.dimensions.components.readingParagraphGap),
      child: Text(text, style: AppTheme.typography.of(context).lead.copyWith(color: AppTheme.colors.ink)),
    );
  }
}

/// Parágrafo de texto de leitura.
class ReadingParagraph extends StatelessWidget {
  const ReadingParagraph(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppTheme.dimensions.components.readingParagraphGap),
      child: Text(text, style: AppTheme.typography.of(context).reading.copyWith(color: AppTheme.colors.ink)),
    );
  }
}

/// Lista numerada (`.manifest-list`): número num círculo laranja suave e
/// texto ao lado, com as linhas quebradas alinhadas ao texto.
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
                  child: Text('$number', style: styles.readingListNumber.copyWith(color: colors.accentStrong)),
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

/// Frase de destaque com barra laranja à esquerda (`.prose blockquote`).
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
        child: Text(text, style: AppTheme.typography.of(context).readingQuote.copyWith(color: colors.ink)),
      ),
    );
  }
}
