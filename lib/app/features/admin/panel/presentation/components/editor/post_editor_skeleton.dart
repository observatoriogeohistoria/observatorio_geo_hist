import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/skeleton/skeleton.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_layout.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostEditorSkeleton extends StatelessWidget {
  const PostEditorSkeleton({required this.controller, super.key});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;

    Widget block(double height) => ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r8),
          child: Skeleton(width: double.infinity, height: height),
        );

    return Semantics(
      label: 'Carregando a publicação',
      child: ExcludeSemantics(
        child: PostEditorLayout(
          controller: controller,
          main: [
            PostEditorCard(
              children: [
                block(components.editorSkeletonTitleHeight),
                block(components.editorSkeletonLineHeight),
                block(components.editorSkeletonBlockHeight),
              ],
            ),
          ],
          side: [
            for (var i = 0; i < 3; i++)
              PostEditorCard(children: [block(components.editorSkeletonSideHeight)]),
          ],
        ),
      ),
    );
  }
}
