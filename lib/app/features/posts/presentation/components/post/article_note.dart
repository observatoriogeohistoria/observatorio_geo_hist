import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_rich_text.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class ArticleNote extends StatelessWidget {
  const ArticleNote({super.key, required this.observation});

  final String? observation;

  @override
  Widget build(BuildContext context) {
    if (ReadingRichText.isEmpty(observation)) return const SizedBox.shrink();

    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final label = AppTheme.typography.of(context).label;
    final scale = MediaQuery.textScalerOf(context).scale(1);

    return Container(
      padding: EdgeInsets.fromLTRB(
        components.postNotePaddingHorizontal,
        components.postNotePaddingVertical,
        components.postNotePaddingHorizontal,
        components.postNotePaddingVertical - components.readingParagraphGap,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ExcludeSemantics(
                child: Icon(
                  Icons.description_outlined,
                  size: label.fontSize! * components.buttonIconScale * scale,
                  color: colors.accentStrong,
                ),
              ),
              SizedBox(width: components.postNoteIconGap),
              Semantics(header: true, child: Text('NOTA', style: label.copyWith(color: colors.accentStrong))),
            ],
          ),
          SizedBox(height: components.postNoteLabelGap),
          ReadingRichText(observation),
        ],
      ),
    );
  }
}
