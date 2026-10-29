import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_text_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/chips/labels.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/date/date.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/labels/post_type_panel_labels.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

enum PostEditorAction {
  publish,
  saveDraft,
  saveChanges,
  unpublish;

  String get label => switch (this) {
        PostEditorAction.publish => 'Publicar',
        PostEditorAction.saveDraft => 'Salvar rascunho',
        PostEditorAction.saveChanges => 'Salvar alterações',
        PostEditorAction.unpublish => 'Despublicar',
      };

  bool get publishes => this == publish || this == saveChanges;
}

class PostEditorBar extends StatelessWidget {
  const PostEditorBar({
    required this.type,
    required this.title,
    required this.onBack,
    required this.onAction,
    this.isLoaded = true,
    this.isPublished = false,
    this.isNew = true,
    this.savedAt,
    this.saving,
    super.key,
  });

  final PostType type;
  final String title;
  final VoidCallback onBack;
  final ValueChanged<PostEditorAction> onAction;

  /// Without the post loaded there's no status to show nor anything to save.
  final bool isLoaded;
  final bool isPublished;
  final bool isNew;
  final DateTime? savedAt;
  final PostEditorAction? saving;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final breakpoint = ScreenUtils.breakpointOf(context);
    final isMobile = breakpoint == Breakpoint.mobile;
    final savedAt = this.savedAt;

    final back = Semantics(
      button: true,
      label: 'Voltar para ${type.panelPlural}',
      onTap: onBack,
      excludeSemantics: true,
      child: AppTextButton.small(
        text: type.panelPlural,
        leadingIcon: Icons.arrow_back,
        onPressed: onBack,
      ),
    );

    final heading = Semantics(
      header: true,
      child: Text(
        title,
        maxLines: isMobile ? 1 : null,
        overflow: isMobile ? TextOverflow.ellipsis : null,
        style: styles.editorBarTitle.copyWith(color: colors.ink),
      ),
    );
    final badge = isPublished
        ? const StatusBadge('Publicado', tone: StatusTone.success)
        : const StatusBadge('Não publicado', tone: StatusTone.neutral);
    final saved = Text(
      isNew
          ? 'Ainda não salvo'
          : savedAt == null
              ? 'Salvo'
              : 'Salvo pela última vez em ${savedAt.shortDate}',
      style: styles.panelRowMeta.copyWith(color: colors.inkSecondary),
    );

    final Widget titleArea = isMobile
        ? Row(
            children: [
              Flexible(child: heading),
              if (isLoaded) ...[SizedBox(width: components.editorBarTitleGap), badge],
            ],
          )
        : Wrap(
            spacing: components.editorBarTitleGap,
            runSpacing: components.editorBarGapV / 2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              heading,
              if (isLoaded) ...[badge, saved]
            ],
          );

    final secondaryAction = isPublished ? PostEditorAction.unpublish : PostEditorAction.saveDraft;
    final primaryAction = isPublished ? PostEditorAction.saveChanges : PostEditorAction.publish;
    final isSaving = saving != null;
    final secondary = SecondaryButton.small(
      text: saving == secondaryAction ? 'Salvando…' : secondaryAction.label,
      isLoading: saving == secondaryAction,
      isDisabled: isSaving && saving != secondaryAction,
      expand: isMobile,
      onPressed: () => onAction(secondaryAction),
    );
    final primary = PrimaryButton.small(
      text: saving == primaryAction ? 'Salvando…' : primaryAction.label,
      isLoading: saving == primaryAction,
      isDisabled: isSaving && saving != primaryAction,
      expand: isMobile,
      onPressed: () => onAction(primaryAction),
    );
    final actionsGap = SizedBox(width: components.editorBarActionsGap);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.page,
        border: Border(
          bottom: BorderSide(color: colors.line, width: AppTheme.dimensions.stroke.small),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: components.editorBarPaddingH(breakpoint),
          vertical: components.editorBarPaddingV,
        ),
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      back,
                      SizedBox(width: components.editorBarGapH),
                      Expanded(child: titleArea),
                    ],
                  ),
                  if (isLoaded) ...[
                    SizedBox(height: components.editorBarGapV),
                    Row(
                      children: [
                        Expanded(child: secondary),
                        actionsGap,
                        Expanded(child: primary),
                      ],
                    ),
                  ],
                ],
              )
            : Row(
                children: [
                  back,
                  SizedBox(width: components.editorBarGapH),
                  Expanded(child: titleArea),
                  if (isLoaded) ...[
                    SizedBox(width: components.editorBarGapH),
                    secondary,
                    actionsGap,
                    primary,
                  ],
                ],
              ),
      ),
    );
  }
}
