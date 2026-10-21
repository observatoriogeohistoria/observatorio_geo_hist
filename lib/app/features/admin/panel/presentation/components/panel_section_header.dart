import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PanelSectionHeader extends StatefulWidget {
  const PanelSectionHeader({
    required this.eyebrow,
    required this.title,
    this.summary,
    this.actionLabel,
    this.actionIcon = Icons.add,
    this.onAction,
    this.isActionDisabled = false,
    super.key,
  });

  final String eyebrow;
  final String title;
  final String? summary;

  /// Sem [actionLabel] ou [onAction] o botão não aparece (quem só pode ver, por exemplo).
  final String? actionLabel;
  final IconData actionIcon;
  final VoidCallback? onAction;
  final bool isActionDisabled;

  @override
  State<PanelSectionHeader> createState() => _PanelSectionHeaderState();
}

class _PanelSectionHeaderState extends State<PanelSectionHeader> {
  final _titleFocus = FocusNode(skipTraversal: true);

  @override
  void initState() {
    super.initState();
    _focusTitle();
  }

  // Trocar de seção ou de tipo leva o foco ao título, para o leitor de tela anunciar onde se está.
  @override
  void didUpdateWidget(covariant PanelSectionHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.title != widget.title) _focusTitle();
  }

  void _focusTitle() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _titleFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final isMobile = ScreenUtils.isMobile(context);
    final summary = widget.summary;
    final actionLabel = widget.actionLabel;
    final onAction = widget.onAction;

    final texts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.eyebrow.toUpperCase(),
          style: styles.label.copyWith(color: colors.accentStrong),
        ),
        SizedBox(height: components.panelHeadTitleGap),
        Focus(
          focusNode: _titleFocus,
          child: Semantics(
            header: true,
            child: Text(widget.title, style: styles.panelSectionTitle.copyWith(color: colors.ink)),
          ),
        ),
        if (summary != null) ...[
          SizedBox(height: components.panelHeadSummaryGap),
          Text(summary, style: styles.panelSectionSummary.copyWith(color: colors.inkSecondary)),
        ],
      ],
    );

    final button = actionLabel == null || onAction == null
        ? null
        : PrimaryButton.medium(
            text: actionLabel,
            leadingIcon: widget.actionIcon,
            onPressed: onAction,
            isDisabled: widget.isActionDisabled,
            expand: isMobile,
          );

    return Padding(
      padding: EdgeInsets.only(bottom: components.panelHeadMarginBottom),
      child: isMobile || button == null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                texts,
                if (button != null) ...[
                  SizedBox(height: components.panelHeadActionGap),
                  button,
                ],
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: texts),
                SizedBox(width: components.panelHeadActionGap),
                button,
              ],
            ),
    );
  }
}

/// "12 categorias · nota". Sem a contagem (carregando ou com falha) fica só a nota.
String? countSummary(int? count, String singular, String plural, {String? note}) {
  if (count == null) {
    if (note == null || note.isEmpty) return null;
    return note[0].toUpperCase() + note.substring(1);
  }
  final counted = '$count ${count == 1 ? singular : plural}';
  return note == null ? counted : '$counted · $note';
}
