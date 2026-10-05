import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/chips/labels.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class FactSheet extends StatelessWidget {
  const FactSheet({super.key, required this.facts, this.tagsLabel = '', this.tags = const []});

  final List<(String label, String value)> facts;
  final String tagsLabel;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final line = BorderSide(color: colors.line, width: AppTheme.dimensions.stroke.small);
    final facts = [
      for (final (label, value) in this.facts)
        if (value.trim().isNotEmpty) (label, value.trim()),
    ];
    final tags = [
      for (final tag in this.tags)
        if (tag.trim().isNotEmpty) tag.trim(),
    ];

    if (facts.isEmpty && tags.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(top: components.factsTop),
      padding: EdgeInsets.symmetric(vertical: components.factsPaddingV),
      decoration: BoxDecoration(border: Border(top: line, bottom: line)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final gap = components.factsGapH;
          final columns = ((width + gap) / (components.factsMinColumn + gap))
              .floor()
              .clamp(1, components.factsMaxColumns);
          final columnWidth = (width - gap * (columns - 1)) / columns;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (facts.isNotEmpty)
                Wrap(
                  spacing: gap,
                  runSpacing: components.factsGapV,
                  children: [
                    for (final (label, value) in facts)
                      SizedBox(
                        width: columnWidth,
                        child: _Fact(
                          label: label,
                          spokenValue: value,
                          child: Text(
                            value,
                            style: AppTheme.typography
                                .of(context)
                                .factValue
                                .copyWith(color: colors.ink),
                          ),
                        ),
                      ),
                  ],
                ),
              if (facts.isNotEmpty && tags.isNotEmpty) SizedBox(height: components.factsGapV),
              if (tags.isNotEmpty)
                _Fact(
                  label: tagsLabel,
                  spokenValue: tags.join(', '),
                  child: Wrap(
                    spacing: components.tagGap,
                    runSpacing: components.tagGap,
                    children: [for (final tag in tags) CategoryTag(tag)],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.spokenValue, required this.child});

  final String label;
  final String spokenValue;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: '$label, $spokenValue',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style:
                AppTheme.typography.of(context).label.copyWith(color: AppTheme.colors.inkSecondary),
          ),
          SizedBox(height: AppTheme.dimensions.components.factLabelGap),
          child,
        ],
      ),
    );
  }
}
