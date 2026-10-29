import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/form/form_field_frame.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/listing/library_filter_select.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PanelSelectField<T> extends StatefulWidget {
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

  /// The option with a `null` value is the "nothing chosen" one.
  final List<LibraryFilterOption<T?>> options;
  final T? value;
  final ValueChanged<T?> onSelected;
  final String? Function(T?)? validator;
  final GlobalKey<FormFieldState<T>>? formFieldKey;
  final FocusNode? focusNode;

  @override
  State<PanelSelectField<T>> createState() => _PanelSelectFieldState<T>();
}

class _PanelSelectFieldState<T> extends State<PanelSelectField<T>> {
  // Form validates before rebuilding the fields; keeping the choice here stops validation from
  // seeing the previous option and leaving the error on screen.
  late T? _value = widget.value;

  @override
  void didUpdateWidget(covariant PanelSelectField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.label;

    return FormField<T>(
      key: widget.formFieldKey,
      initialValue: _value,
      validator: (_) => widget.validator?.call(_value),
      builder: (field) {
        final error = field.errorText;

        return FormFieldFrame(
          label: label,
          errorText: error,
          child: LibraryFilterSelect<T?>(
            semanticLabel: error == null ? label : '$label. $error',
            options: widget.options,
            value: _value,
            focusNode: widget.focusNode,
            hasError: error != null,
            height: AppTheme.dimensions.components.formFieldHeight,
            expand: true,
            onSelected: (choice) {
              _value = choice;
              widget.onSelected(choice);
              field.didChange(choice);
            },
          ),
        );
      },
    );
  }
}
