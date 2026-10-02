import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/chips/filter_chip_button.dart';
import 'package:observatorio_geo_hist/app/core/components/field/search_field.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class ListingToolbar extends StatelessWidget {
  const ListingToolbar({
    super.key,
    required this.searchKey,
    required this.controller,
    required this.onSearch,
    required this.types,
    required this.counts,
    required this.selectedType,
    required this.onSelectType,
  });

  /// Mantém o campo (e o foco) quando os chips mudam a disposição da barra.
  final GlobalKey searchKey;
  final TextEditingController controller;
  final ValueChanged<String> onSearch;

  /// Vazio esconde os chips.
  final List<PostType> types;
  final Map<PostType, int>? counts;
  final PostType? selectedType;
  final ValueChanged<PostType?> onSelectType;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final counts = this.counts;
    final total =
        counts == null ? null : types.fold<int>(0, (sum, type) => sum + (counts[type] ?? 0));

    final chips = [
      (label: 'Todos', count: total, type: null),
      for (final type in types) (label: type.portuguesePlural, count: counts?[type], type: type),
    ];
    final search = SearchField(
      key: searchKey,
      controller: controller,
      hint: 'Buscar por título',
      semanticLabel: 'Buscar por título',
      onSearch: onSearch,
    );
    final chipsRow = Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Filtrar por tipo',
      child: Wrap(
        spacing: components.chipGap,
        runSpacing: components.chipGap,
        children: [
          for (final chip in chips)
            FilterChipButton(
              label: chip.label,
              count: chip.count,
              selected: selectedType == chip.type,
              onPressed: () => onSelectType(chip.type),
            ),
        ],
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final searchMaxWidth = math.min(width, components.searchFieldMaxWidth);
        if (types.isEmpty) {
          return Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(width: searchMaxWidth, child: search),
          );
        }

        final chipsWidth = chips.fold<double>(
              0,
              (sum, chip) => sum + FilterChipButton.measure(context, chip.label, chip.count),
            ) +
            components.chipGap * (chips.length - 1);
        final searchWidth = math.min(
          components.searchFieldMaxWidth,
          width - chipsWidth - components.listingToolbarGap,
        );

        // A busca encolhe até o mínimo para os chips caberem ao lado; abaixo disso, descem.
        if (searchWidth >= components.searchFieldMinWidth) {
          return Row(
            children: [
              SizedBox(width: searchWidth, child: search),
              SizedBox(width: components.listingToolbarGap),
              Expanded(child: Align(alignment: Alignment.centerRight, child: chipsRow)),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: searchMaxWidth, child: search),
            SizedBox(height: components.listingToolbarGap),
            chipsRow,
          ],
        );
      },
    );
  }
}
