import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_text_button.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/listing/library_filter_select.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

String documentsCount(int count) => count == 1 ? '1 documento' : '$count documentos';

class LibraryCategoryFilter extends StatefulWidget {
  const LibraryCategoryFilter({
    super.key,
    required this.categories,
    required this.counts,
    required this.selected,
    required this.onToggle,
    required this.onClear,
  });

  final List<DocumentCategory> categories;

  /// Nulo sem contagem: as categorias aparecem sem números.
  final Map<DocumentCategory, int>? counts;
  final List<DocumentCategory> selected;
  final ValueChanged<DocumentCategory> onToggle;
  final VoidCallback onClear;

  @override
  State<LibraryCategoryFilter> createState() => _LibraryCategoryFilterState();
}

class _LibraryCategoryFilterState extends State<LibraryCategoryFilter> {
  final _controller = MenuController();
  final _buttonFocus = FocusNode();
  final _firstFocus = FocusNode();
  final _panelFocus = FocusNode(canRequestFocus: false, skipTraversal: true);

  @override
  void dispose() {
    _buttonFocus.dispose();
    _firstFocus.dispose();
    _panelFocus.dispose();
    super.dispose();
  }

  void _toggle() {
    _controller.isOpen ? _controller.close() : _controller.open();
    setState(() {});
  }

  void _handleOpen() {
    if (!_buttonFocus.hasFocus) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_controller.isOpen) _firstFocus.requestFocus();
    });
  }

  // O menu prende o Tab dentro dele; aqui o Tab sai do painel (as setas andam entre as caixas).
  KeyEventResult _handlePanelKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || event.logicalKey != LogicalKeyboardKey.tab) {
      return KeyEventResult.ignored;
    }
    final backwards = HardwareKeyboard.instance.isShiftPressed;
    _controller.close();
    _buttonFocus.requestFocus();
    if (!backwards) {
      SchedulerBinding.instance.addPostFrameCallback((_) => _buttonFocus.nextFocus());
    }
    setState(() {});
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final selectedCount = widget.selected.length;
    final screen = MediaQuery.sizeOf(context).width;
    final margin = ScreenUtils.contentMargin(ScreenUtils.breakpointOf(context));
    final panelWidth = math.min(components.libraryPanelMaxWidth, screen - margin * 2);
    final counts = widget.counts;

    return CheckboxTheme(
      data: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? colors.accent : Colors.transparent,
        ),
        checkColor: WidgetStatePropertyAll(colors.white),
        side: BorderSide(color: colors.inkSecondary, width: AppTheme.dimensions.stroke.medium),
      ),
      child: MenuAnchor(
        controller: _controller,
        childFocusNode: _buttonFocus,
        // O clique fora só fecha o menu; sem isso, também abria o documento embaixo.
        consumeOutsideTap: true,
        onOpen: _handleOpen,
        onClose: () => setState(() {}),
        style: libraryMenuStyle(),
        alignmentOffset: Offset(0, components.libraryPanelOffset),
        menuChildren: [
          Focus(
            focusNode: _panelFocus,
            onKeyEvent: _handlePanelKey,
            child: SizedBox(
              width: panelWidth - components.libraryPanelPadding * 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (index, category) in widget.categories.indexed)
                    Semantics(
                      checked: widget.selected.contains(category),
                      child: MenuItemButton(
                        focusNode: index == 0 ? _firstFocus : null,
                        closeOnActivate: false,
                        requestFocusOnHover: false,
                        overflowAxis: Axis.vertical,
                        style: libraryMenuItemStyle(context),
                        onPressed: () => widget.onToggle(category),
                        leadingIcon: ExcludeSemantics(
                          child: IgnorePointer(
                            child: SizedBox.square(
                              dimension: Checkbox.width,
                              child: Checkbox(
                                value: widget.selected.contains(category),
                                onChanged: (_) {},
                              ),
                            ),
                          ),
                        ),
                        trailingIcon: counts == null
                            ? null
                            : ExcludeSemantics(
                                child: Text(
                                  '${counts[category] ?? 0}',
                                  style: styles.small.copyWith(
                                    color: colors.inkSecondary,
                                    fontFeatures: const [FontFeature.tabularFigures()],
                                  ),
                                ),
                              ),
                        child: Semantics(
                          label: counts == null
                              ? category.value
                              : '${category.value}, ${documentsCount(counts[category] ?? 0)}',
                          excludeSemantics: true,
                          child: Text(category.value),
                        ),
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.only(top: components.libraryPanelOffset),
                    padding: EdgeInsets.only(top: components.libraryPanelFooterPaddingTop),
                    decoration: BoxDecoration(border: Border(top: BorderSide(color: colors.line))),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                              start: components.libraryPanelItemPadding,
                            ),
                            child: Text(
                              'Selecione quantas quiser',
                              style: styles.small.copyWith(color: colors.inkSecondary),
                            ),
                          ),
                        ),
                        AppTextButton.small(text: 'Limpar', onPressed: widget.onClear),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        builder: (context, controller, _) => LibraryFilterButton(
          focusNode: _buttonFocus,
          semanticLabel: 'Categoria',
          semanticValue: switch (selectedCount) {
            0 => null,
            1 => '1 selecionada',
            _ => '$selectedCount selecionadas',
          },
          expanded: controller.isOpen,
          onPressed: _toggle,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Categoria'),
              if (selectedCount > 0) ...[
                SizedBox(width: components.libraryFilterIconGap),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: components.libraryFilterBadgePaddingH,
                    vertical: components.libraryFilterBadgePaddingV,
                  ),
                  decoration: BoxDecoration(
                    color: colors.accent,
                    borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.pill),
                  ),
                  child: Text(
                    '$selectedCount',
                    style: styles.libraryTag.copyWith(
                      color: colors.white,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
