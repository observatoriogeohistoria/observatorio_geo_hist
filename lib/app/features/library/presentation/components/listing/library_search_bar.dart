import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/field/search_field.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/datasources/library_datasource.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/listing/library_filter_select.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LibrarySearchBar extends StatelessWidget {
  const LibrarySearchBar({
    super.key,
    required this.controller,
    required this.field,
    required this.onFieldChanged,
    required this.onSearch,
  });

  final TextEditingController controller;
  final LibrarySearchField field;
  final ValueChanged<LibrarySearchField> onFieldChanged;
  final ValueChanged<String> onSearch;

  static String _capitalized(String text) => text[0].toUpperCase() + text.substring(1);

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final mobile = ScreenUtils.breakpointOf(context) == Breakpoint.mobile;
    final hint = 'Buscar por ${field.label}';

    final selector = LibraryFilterSelect<LibrarySearchField>(
      semanticLabel: 'Buscar em',
      height: components.searchFieldHeight,
      expand: mobile,
      value: field,
      options: [
        for (final option in LibrarySearchField.values)
          LibraryFilterOption(option, _capitalized(option.label)),
      ],
      labelBuilder: (option) => 'Buscar em: ${option.label}',
      onSelected: onFieldChanged,
    );
    final search = SearchField(
      controller: controller,
      hint: hint,
      semanticLabel: hint,
      onSearch: onSearch,
    );

    if (mobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [selector, SizedBox(height: components.libraryFilterGap), search],
      );
    }

    return Row(
      children: [
        selector,
        SizedBox(width: components.libraryFilterGap),
        Expanded(child: search),
      ],
    );
  }
}
