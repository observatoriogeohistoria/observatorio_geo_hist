import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// A busca estica para ocupar o que sobra da linha; no celular, fica sozinha na primeira linha.
class PanelFilterBar extends StatelessWidget {
  const PanelFilterBar({
    this.leading = const [],
    this.search,
    this.filters = const [],
    this.below,
    super.key,
  });

  /// Antes da busca, como a troca de área da biblioteca.
  final List<Widget> leading;
  final Widget? search;
  final List<Widget> filters;

  /// Segunda linha, por exemplo os filtros extras da biblioteca.
  final Widget? below;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final search = this.search;
    final below = this.below;

    return Padding(
      padding: EdgeInsets.only(bottom: components.panelFilterMarginBottom),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.page,
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r14),
          border: Border.all(color: colors.line, width: AppTheme.dimensions.stroke.small),
        ),
        child: Padding(
          padding: EdgeInsets.all(components.panelFilterPadding),
          child: FocusTraversalGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _FilterWrap(
                  searchIndex: search == null ? null : leading.length,
                  searchOwnLine: ScreenUtils.isMobile(context),
                  spacing: components.panelFilterGap,
                  searchMinWidth: components.panelFilterSearchMinWidth,
                  children: [...leading, if (search != null) search, ...filters],
                ),
                if (below != null) ...[
                  SizedBox(height: components.panelFilterGap),
                  below,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterWrap extends MultiChildRenderObjectWidget {
  const _FilterWrap({
    required this.searchIndex,
    required this.searchOwnLine,
    required this.spacing,
    required this.searchMinWidth,
    required super.children,
  });

  final int? searchIndex;
  final bool searchOwnLine;
  final double spacing;
  final double searchMinWidth;

  @override
  _RenderFilterWrap createRenderObject(BuildContext context) => _RenderFilterWrap(
        searchIndex: searchIndex,
        searchOwnLine: searchOwnLine,
        spacing: spacing,
        searchMinWidth: searchMinWidth,
      );

  @override
  void updateRenderObject(BuildContext context, _RenderFilterWrap renderObject) {
    renderObject
      ..searchIndex = searchIndex
      ..searchOwnLine = searchOwnLine
      ..spacing = spacing
      ..searchMinWidth = searchMinWidth;
  }
}

class _FilterWrapParentData extends ContainerBoxParentData<RenderBox> {}

// O Wrap do Flutter não deixa um filho esticar; aqui a busca ganha a sobra da sua linha.
class _RenderFilterWrap extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _FilterWrapParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _FilterWrapParentData> {
  _RenderFilterWrap({
    required int? searchIndex,
    required bool searchOwnLine,
    required double spacing,
    required double searchMinWidth,
  })  : _searchIndex = searchIndex,
        _searchOwnLine = searchOwnLine,
        _spacing = spacing,
        _searchMinWidth = searchMinWidth;

  int? _searchIndex;
  set searchIndex(int? value) {
    if (value == _searchIndex) return;
    _searchIndex = value;
    markNeedsLayout();
  }

  bool _searchOwnLine;
  set searchOwnLine(bool value) {
    if (value == _searchOwnLine) return;
    _searchOwnLine = value;
    markNeedsLayout();
  }

  double _spacing;
  set spacing(double value) {
    if (value == _spacing) return;
    _spacing = value;
    markNeedsLayout();
  }

  double _searchMinWidth;
  set searchMinWidth(double value) {
    if (value == _searchMinWidth) return;
    _searchMinWidth = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _FilterWrapParentData) child.parentData = _FilterWrapParentData();
  }

  @override
  void performLayout() {
    final maxWidth = constraints.maxWidth;
    final children = getChildrenAsList();
    final searchAt = _searchIndex;
    final search = searchAt != null && searchAt < children.length ? children[searchAt] : null;

    final widths = <RenderBox, double>{};
    for (final child in children) {
      if (child == search) {
        widths[child] = _searchOwnLine ? maxWidth : math.min(_searchMinWidth, maxWidth);
      } else {
        child.layout(BoxConstraints(maxWidth: maxWidth), parentUsesSize: true);
        widths[child] = child.size.width;
      }
    }

    final lines = <List<RenderBox>>[];
    var line = <RenderBox>[];
    var used = 0.0;
    for (final child in children) {
      final width = widths[child]!;
      final needed = line.isEmpty ? width : used + _spacing + width;
      final ownLine = child == search && _searchOwnLine;
      if (line.isNotEmpty && (needed > maxWidth || ownLine)) {
        lines.add(line);
        line = [child];
        used = width;
      } else {
        line.add(child);
        used = needed;
      }
      if (child == search && _searchOwnLine) {
        lines.add(line);
        line = [];
        used = 0;
      }
    }
    if (line.isNotEmpty) lines.add(line);

    if (search != null) {
      final searchLine = lines.firstWhere((line) => line.contains(search));
      final others = searchLine.where((child) => child != search);
      final othersWidth = others.fold(0.0, (sum, child) => sum + widths[child]! + _spacing);
      final width = math.max(0.0, maxWidth - othersWidth);
      search.layout(BoxConstraints.tightFor(width: width), parentUsesSize: true);
    }

    var y = 0.0;
    for (final (index, line) in lines.indexed) {
      if (index > 0) y += _spacing;
      final height = line.fold(0.0, (max, child) => math.max(max, child.size.height));
      var x = 0.0;
      for (final child in line) {
        (child.parentData! as _FilterWrapParentData).offset =
            Offset(x, y + (height - child.size.height) / 2);
        x += child.size.width + _spacing;
      }
      y += height;
    }

    size = constraints.constrain(Size(maxWidth, y));
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) => defaultPaint(context, offset);
}
