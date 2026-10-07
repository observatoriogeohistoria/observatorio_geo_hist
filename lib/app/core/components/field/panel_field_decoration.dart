import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

abstract final class PanelFieldDecoration {
  static TextStyle textStyle(BuildContext context) {
    return AppTheme.typography.of(context).regular.copyWith(color: AppTheme.colors.ink);
  }

  static TextStyle secondaryStyle(BuildContext context) {
    return AppTheme.typography.of(context).regular.copyWith(color: AppTheme.colors.inkSecondary);
  }

  static InputDecoration build(
    BuildContext context, {
    String? labelText,
    String? hintText,
    Widget? suffixIcon,
    BoxConstraints? suffixIconConstraints,
    bool alignLabelWithHint = false,
  }) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final secondary = secondaryStyle(context);

    return InputDecoration(
      alignLabelWithHint: alignLabelWithHint,
      labelText: labelText,
      labelStyle: secondary,
      floatingLabelStyle: secondary,
      hintText: hintText,
      hintStyle: secondary,
      errorStyle: AppTheme.typography.of(context).formError.copyWith(color: colors.error),
      errorMaxLines: components.formErrorMaxLines,
      suffixIcon: suffixIcon,
      suffixIconConstraints: suffixIconConstraints,
      filled: true,
      fillColor: WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.disabled) ? colors.surface : colors.page,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: components.formFieldPaddingH,
        vertical: components.formFieldPaddingV,
      ),
      enabledBorder: _border(colors.fieldBorder),
      disabledBorder: _border(colors.fieldBorder),
      focusedBorder: _border(colors.accent, width: components.panelFieldFocusedBorder),
      errorBorder: _border(colors.error),
      focusedErrorBorder: _border(colors.error, width: components.panelFieldFocusedBorder),
    );
  }

  static OutlineInputBorder _border(Color color, {double? width}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r10),
      borderSide: BorderSide(
        color: color,
        width: width ?? AppTheme.dimensions.components.formFieldBorder,
      ),
    );
  }
}
