import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_form.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostEditorMissingAlert extends StatelessWidget {
  const PostEditorMissingAlert({
    required this.title,
    required this.fields,
    required this.focusNode,
    required this.onSelect,
    super.key,
  });

  final String title;
  final List<PostEditorField> fields;
  final FocusNode focusNode;
  final ValueChanged<PostEditorField> onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final style = styles.formError.copyWith(color: colors.error);
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r12);

    return Semantics(
      liveRegion: true,
      container: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Focus(
          focusNode: focusNode,
          child: DecoratedBox(
            decoration: BoxDecoration(color: colors.errorSurface, borderRadius: radius),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: components.formAlertPaddingH,
                vertical: components.formAlertPaddingV,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      Icons.error_outline,
                      size: components.formAlertIcon,
                      color: colors.error,
                    ),
                  ),
                  SizedBox(width: components.formAlertGap),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: style.copyWith(fontWeight: FontWeight.w700)),
                        for (final field in fields)
                          Semantics(
                            link: true,
                            label: field.label,
                            excludeSemantics: true,
                            onTap: () => onSelect(field),
                            child: AppFocusRing(
                              borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r6),
                              child: InkWell(
                                onTap: () => onSelect(field),
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                child: Padding(
                                  padding: EdgeInsets.only(top: components.formFieldLabelGap),
                                  child: Text.rich(
                                    TextSpan(
                                      text: '•  ',
                                      children: [
                                        TextSpan(
                                          text: field.label,
                                          style: TextStyle(
                                            decoration: TextDecoration.underline,
                                            decorationColor: colors.error,
                                          ),
                                        ),
                                      ],
                                    ),
                                    style: style,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
