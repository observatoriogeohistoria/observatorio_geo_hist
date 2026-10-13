import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/listing/library_filter_select.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PanelAreaFilter extends StatelessWidget {
  const PanelAreaFilter({required this.value, required this.onChanged, super.key});

  final PostsAreas? value;
  final ValueChanged<PostsAreas?> onChanged;

  @override
  Widget build(BuildContext context) {
    return LibraryFilterSelect<PostsAreas?>(
      semanticLabel: 'Área',
      height: AppTheme.dimensions.components.panelControlHeight,
      options: [
        const LibraryFilterOption(null, 'Todas as áreas'),
        for (final area in PostsAreas.values) LibraryFilterOption(area, area.portuguese),
      ],
      value: value,
      onSelected: onChanged,
    );
  }
}
