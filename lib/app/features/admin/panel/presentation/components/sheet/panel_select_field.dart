import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/form/form_field_frame.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/listing/library_filter_select.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PanelSelectField<T> extends StatelessWidget {
  const PanelSelectField({
    required this.label,
    required this.options,
    required this.value,
    required this.onSelected,
    this.validator,
    this.formFieldKey,
    this.focusNode,
    super.key,
  });

  final String label;

  /// A opção de valor `null` é a de "nada escolhido".
  final List<LibraryFilterOption<T?>> options;
  final T? value;
  final ValueChanged<T?> onSelected;
  final String? Function(T?)? validator;
  final GlobalKey<FormFieldState<T>>? formFieldKey;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      key: formFieldKey,
      initialValue: value,
      validator: (_) => validator?.call(value),
      builder: (field) {
        final error = field.errorText;

        return FormFieldFrame(
          label: label,
          errorText: error,
          child: LibraryFilterSelect<T?>(
            semanticLabel: error == null ? label : '$label. $error',
            options: options,
            value: value,
            focusNode: focusNode,
            hasError: error != null,
            height: AppTheme.dimensions.components.formFieldHeight,
            expand: true,
            onSelected: (choice) {
              onSelected(choice);
              field.didChange(choice);
            },
          ),
        );
      },
    );
  }
}
