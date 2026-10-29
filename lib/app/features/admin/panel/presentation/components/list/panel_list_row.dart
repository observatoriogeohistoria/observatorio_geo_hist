import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PanelListRow extends StatefulWidget {
  const PanelListRow({
    required this.leading,
    required this.title,
    this.meta,
    this.badges = const [],
    this.actions = const [],
    super.key,
  });

  final Widget leading;
  final String title;
  final String? meta;
  final List<Widget> badges;

  /// Empty for view-only users: the actions column isn't even built.
  final List<Widget> actions;

  @override
  State<PanelListRow> createState() => _PanelListRowState();
}

class _PanelListRowState extends State<PanelListRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final isMobile = ScreenUtils.isMobile(context);
    final meta = widget.meta;

    final texts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ExcludeSemantics(
          child: Text(
            widget.title,
            maxLines: components.panelRowTitleMaxLines,
            overflow: TextOverflow.ellipsis,
            style: styles.panelRowTitle.copyWith(color: colors.ink),
          ),
        ),
        if (meta != null && meta.isNotEmpty) ...[
          SizedBox(height: components.panelRowMetaGap),
          Text(
            meta,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: styles.panelRowMeta.copyWith(color: colors.inkSecondary),
          ),
        ],
      ],
    );

    final hasBadges = widget.badges.isNotEmpty;
    final hasActions = widget.actions.isNotEmpty;

    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (index, action) in widget.actions.indexed) ...[
          if (index > 0) SizedBox(width: components.panelRowActionsGap),
          action,
        ],
      ],
    );

    final Widget content;
    if (isMobile) {
      content = Padding(
        padding: EdgeInsets.all(components.panelRowPaddingMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.leading,
                SizedBox(width: components.panelRowGapMobileH),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      texts,
                      if (hasBadges) ...[
                        SizedBox(height: components.panelRowGapMobileV),
                        Wrap(
                          spacing: components.panelRowBadgeGap,
                          runSpacing: components.panelRowBadgeGap,
                          children: widget.badges,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (hasActions) ...[
              SizedBox(height: components.panelRowGapMobileV),
              CustomPaint(
                painter: _DashedTopLine(color: colors.line),
                child: Padding(
                  padding: EdgeInsets.only(top: components.panelRowActionsTop),
                  child: Align(alignment: Alignment.centerRight, child: actions),
                ),
              ),
            ],
          ],
        ),
      );
    } else {
      content = Padding(
        padding: EdgeInsets.symmetric(
          horizontal: components.panelRowPaddingH,
          vertical: components.panelRowPaddingV,
        ),
        child: Row(
          children: [
            widget.leading,
            SizedBox(width: components.panelRowGap),
            Expanded(child: texts),
            if (hasBadges) ...[
              SizedBox(width: components.panelRowGap),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final (index, badge) in widget.badges.indexed) ...[
                    if (index > 0) SizedBox(width: components.panelRowBadgeGap),
                    badge,
                  ],
                ],
              ),
            ],
            if (hasActions) ...[
              SizedBox(width: components.panelRowGap),
              actions,
            ],
          ],
        ),
      );
    }

    // The title becomes the group's name, so the screen reader says which item the actions belong to.
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: widget.title,
      child: FocusTraversalGroup(
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: ColoredBox(
            color: _hovered ? colors.rowHover : Colors.transparent,
            child: content,
          ),
        ),
      ),
    );
  }
}

class _DashedTopLine extends CustomPainter {
  _DashedTopLine({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final components = AppTheme.dimensions.components;
    final paint = Paint()
      ..color = color
      ..strokeWidth = AppTheme.dimensions.stroke.small;
    final y = paint.strokeWidth / 2;
    for (var x = 0.0; x < size.width; x += components.panelRowDash + components.panelRowDashGap) {
      final end = (x + components.panelRowDash).clamp(0.0, size.width);
      canvas.drawLine(Offset(x, y), Offset(end, y), paint);
    }
  }

  @override
  bool shouldRepaint(_DashedTopLine oldDelegate) => oldDelegate.color != color;
}
