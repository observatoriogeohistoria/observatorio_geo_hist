import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/chips/labels.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LibraryDocumentRow extends StatefulWidget {
  const LibraryDocumentRow({super.key, required this.document});

  final LibraryDocumentModel document;

  @override
  State<LibraryDocumentRow> createState() => _LibraryDocumentRowState();
}

class _LibraryDocumentRowState extends State<LibraryDocumentRow> {
  bool _hovered = false;

  LibraryDocumentModel get _document => widget.document;

  String? get _route {
    final id = _document.id;
    return id == null || id.isEmpty ? null : AppRoutes.libraryDocument(_document.area.routeKey, id);
  }

  String get _details => [
        _document.author,
        _document.institution ?? '',
        _document.year?.toString() ?? '',
      ].map((part) => part.trim()).where((part) => part.isNotEmpty).join(' · ');

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final route = _route;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r12);
    final duration =
        MediaQuery.disableAnimationsOf(context) ? Duration.zero : components.libraryDocAnimation;
    final hovered = _hovered && route != null;

    final content = AnimatedContainer(
      duration: duration,
      decoration: BoxDecoration(
        color: hovered ? colors.surface : colors.surface.withValues(alpha: 0),
        borderRadius: radius,
      ),
      padding: EdgeInsets.symmetric(
        vertical: components.libraryDocPaddingV,
        horizontal: components.libraryDocPaddingH,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => _layout(
          context,
          stacked: constraints.maxWidth < components.libraryDocStackBreak,
          hovered: hovered,
          duration: duration,
          showArrow: route != null,
        ),
      ),
    );

    final line = DecoratedBox(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: colors.line))),
      child: content,
    );

    final type = _document.type?.value;
    final label = [
      _document.title,
      if (type != null) type,
      if (_details.isNotEmpty) _details,
    ].join(', ');

    if (route == null) {
      return Semantics(container: true, label: label, excludeSemantics: true, child: line);
    }

    void open() => GoRouter.of(context).go(route);

    return Semantics(
      link: true,
      label: label,
      linkUrl: Uri.parse(route),
      onTap: open,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: open,
            onHover: (value) => setState(() => _hovered = value),
            borderRadius: radius,
            splashFactory: NoSplash.splashFactory,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            mouseCursor: SystemMouseCursors.click,
            child: line,
          ),
        ),
      ),
    );
  }

  Widget _layout(
    BuildContext context, {
    required bool stacked,
    required bool hovered,
    required Duration duration,
    required bool showArrow,
  }) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final categories = _document.categories;
    final type = _document.type;

    final main = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedDefaultTextStyle(
          duration: duration,
          style: styles.libraryDocTitle.copyWith(color: hovered ? colors.accent : colors.ink),
          child: Text(
            _document.title,
            maxLines: components.libraryDocTitleMaxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (_details.isNotEmpty) ...[
          SizedBox(height: components.libraryDocGapV),
          Text(_details, style: styles.meta.copyWith(color: colors.inkSecondary)),
        ],
        if (categories.isNotEmpty) ...[
          SizedBox(height: components.libraryDocGapV),
          Wrap(
            spacing: components.tagGap,
            runSpacing: components.tagGap,
            children: [
              for (final category in categories.take(components.libraryDocMaxCategories))
                CategoryTag(category.value),
              if (categories.length > components.libraryDocMaxCategories)
                CategoryTag('+${categories.length - components.libraryDocMaxCategories}'),
            ],
          ),
        ],
      ],
    );

    final side = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (type != null) TypeBadge(type.value),
        if (type != null && showArrow) SizedBox(width: components.libraryDocSideGap),
        if (showArrow)
          Icon(Icons.arrow_forward, size: components.libraryDocArrow, color: colors.inkSecondary),
      ],
    );
    final hasSide = type != null || showArrow;

    if (stacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          main,
          if (hasSide) ...[
            SizedBox(height: components.libraryDocGapV),
            Align(alignment: Alignment.centerLeft, child: side),
          ],
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: main),
        if (hasSide) ...[SizedBox(width: components.libraryDocGapH), side],
      ],
    );
  }
}
