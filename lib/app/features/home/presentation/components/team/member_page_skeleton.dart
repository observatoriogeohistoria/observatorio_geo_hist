import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/skeleton/skeleton.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/team/member_page_layout.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class MemberPageSkeleton extends StatelessWidget {
  const MemberPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final radii = AppTheme.dimensions.radii;
    final barHeight = components.memberSkeletonBarHeight;

    Widget bar(double widthFactor, double height) => Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: widthFactor,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radii.r6),
              child: Skeleton(width: null, height: height),
            ),
          ),
        );

    return Semantics(
      label: 'Carregando',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          bar(components.memberPageSkeletonCrumbsWidth, barHeight),
          SizedBox(height: components.memberPageTopGap),
          MemberPageLayout(
            portrait: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radii.r20),
                child: const Skeleton(width: null, height: null),
              ),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                bar(components.memberPageSkeletonLabelWidth, barHeight),
                SizedBox(height: components.memberNameTopGap),
                bar(components.memberPageSkeletonNameWidth, components.memberPageSkeletonNameHeight),
                SizedBox(height: components.memberNameBottomGap),
                bar(1, barHeight),
                SizedBox(height: components.memberNameTopGap),
                bar(1, barHeight),
                SizedBox(height: components.memberNameTopGap),
                bar(components.memberPageSkeletonLastLineWidth, barHeight),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
