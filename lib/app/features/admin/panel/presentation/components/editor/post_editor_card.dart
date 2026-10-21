import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostEditorCard extends StatelessWidget {
  const PostEditorCard({required this.children, this.eyebrow, super.key});

  final String? eyebrow;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final eyebrow = this.eyebrow;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.page,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r14),
        border: Border.all(color: colors.line, width: AppTheme.dimensions.stroke.small),
      ),
      child: Padding(
        padding: EdgeInsets.all(components.editorCardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (eyebrow != null) ...[
              Semantics(
                header: true,
                child: Text(
                  eyebrow.toUpperCase(),
                  style: AppTheme.typography
                      .of(context)
                      .editorCardEyebrow
                      .copyWith(color: colors.inkSecondary),
                ),
              ),
              SizedBox(height: components.editorCardEyebrowGap),
            ],
            for (final (index, child) in children.indexed) ...[
              if (index > 0) SizedBox(height: components.formFieldGap),
              child,
            ],
          ],
        ),
      ),
    );
  }
}
