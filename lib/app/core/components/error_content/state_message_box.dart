import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

enum StateMessageTone { neutral, error }

class StateMessageBox extends StatelessWidget {
  const StateMessageBox({
    super.key,
    this.icon,
    this.leading,
    required this.title,
    required this.message,
    this.action,
    this.tone = StateMessageTone.neutral,
    this.titleHeadingLevel,
  }) : assert(icon != null || leading != null);

  final IconData? icon;
  final Widget? leading;
  final String title;
  final String message;
  final Widget? action;
  final StateMessageTone tone;

  /// Só quando a caixa é o conteúdo principal da página; nas listagens ela fica abaixo do h1.
  final int? titleHeadingLevel;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final (iconBackground, iconColor) = switch (tone) {
      StateMessageTone.neutral => (colors.surface, colors.inkSecondary),
      StateMessageTone.error => (colors.errorSurface, colors.error),
    };

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r18),
        border: Border.all(
          color: colors.line,
          width: AppTheme.dimensions.stroke.small,
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: components.stateBoxPaddingVertical,
        horizontal: components.stateBoxPaddingHorizontal,
      ),
      child: Column(
        children: [
          leading ??
              ExcludeSemantics(
                child: Container(
                  width: components.stateBoxIcon,
                  height: components.stateBoxIcon,
                  decoration: BoxDecoration(
                    color: iconBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: components.stateBoxIconGlyph,
                    color: iconColor,
                  ),
                ),
              ),
          SizedBox(height: components.stateBoxGap),
          Semantics(
            liveRegion: true,
            header: titleHeadingLevel != null,
            headingLevel: titleHeadingLevel,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: styles.stateTitle.copyWith(color: colors.ink),
            ),
          ),
          SizedBox(height: components.stateBoxGap),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: components.stateBoxTextMaxWidth,
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: styles.regular.copyWith(color: colors.inkSecondary),
            ),
          ),
          if (action != null) ...[
            SizedBox(
              height: components.stateBoxGap + components.stateBoxButtonGap,
            ),
            action!,
          ],
        ],
      ),
    );
  }
}
