import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/components/form/form_field_frame.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PanelCheckOption<T> {
  const PanelCheckOption(this.value, this.label);

  final T value;
  final String label;
}

class PanelCheckGroup<T> extends StatefulWidget {
  const PanelCheckGroup({
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.boxed = false,
    this.validator,
    this.formFieldKey,
    this.focusNode,
    super.key,
  });

  final String label;
  final List<PanelCheckOption<T>> options;
  final List<T> selected;
  final ValueChanged<List<T>> onChanged;
  final bool boxed;
  final String? Function(List<T>?)? validator;
  final GlobalKey<FormFieldState<List<T>>>? formFieldKey;

  /// Vai para a primeira caixa.
  final FocusNode? focusNode;

  @override
  State<PanelCheckGroup<T>> createState() => _PanelCheckGroupState<T>();
}

class _PanelCheckGroupState<T> extends State<PanelCheckGroup<T>> {
  final _scrollController = ScrollController();

  // O Form valida antes de reconstruir os campos; guardar a escolha aqui evita que a validação
  // veja a marcação anterior e deixe o erro na tela.
  late List<T> _selected = widget.selected;

  @override
  void didUpdateWidget(covariant PanelCheckGroup<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selected = widget.selected;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggle(FormFieldState<List<T>> field, T value) {
    final next = _selected.contains(value)
        ? _selected.where((item) => item != value).toList()
        : [..._selected, value];
    _selected = next;
    widget.onChanged(next);
    field.didChange(next);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);

    return FormField<List<T>>(
      key: widget.formFieldKey,
      initialValue: widget.selected,
      validator: (_) => widget.validator?.call(_selected),
      builder: (field) {
        final error = field.errorText;
        final rows = [
          for (final (index, option) in widget.options.indexed)
            _CheckRow(
              label: option.label,
              value: _selected.contains(option.value),
              focusNode: index == 0 ? widget.focusNode : null,
              compact: widget.boxed,
              onTap: () => _toggle(field, option.value),
            ),
        ];

        final Widget checks = widget.boxed
            ? DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r12),
                  border: Border.all(
                    color: error == null ? colors.line : colors.error,
                    width: components.formFieldBorder,
                  ),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: components.panelCheckBoxMaxHeight),
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: components.panelCheckBoxPaddingH,
                        vertical: components.panelCheckBoxPaddingV,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: rows,
                      ),
                    ),
                  ),
                ),
              )
            : Wrap(
                spacing: components.panelChecksGapH,
                runSpacing: components.panelChecksGapV,
                children: rows,
              );

        return Semantics(
          container: true,
          explicitChildNodes: true,
          label: widget.label,
          hint: FormFieldFrame.semanticHint(error: error),
          child: FormFieldFrame(
            label: widget.label,
            errorText: error,
            child: DefaultTextStyle.merge(
              style: (widget.boxed ? styles.meta : styles.formOption).copyWith(color: colors.ink),
              child: checks,
            ),
          ),
        );
      },
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({
    required this.label,
    required this.value,
    required this.compact,
    required this.onTap,
    this.focusNode,
  });

  final String label;
  final bool value;
  final bool compact;
  final FocusNode? focusNode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r6);

    return MergeSemantics(
      child: AppFocusRing(
        borderRadius: radius,
        child: InkWell(
          focusNode: focusNode,
          onTap: onTap,
          borderRadius: radius,
          hoverColor: colors.surface,
          focusColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: compact ? components.panelCheckBoxRowPaddingV : 0,
            ),
            child: Row(
              mainAxisSize: compact ? MainAxisSize.max : MainAxisSize.min,
              children: [
                ExcludeFocus(
                  child: SizedBox.square(
                    dimension: components.panelCheckSize,
                    child: Checkbox(
                      value: value,
                      onChanged: (_) => onTap(),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      activeColor: colors.accent,
                      checkColor: colors.white,
                      side:
                          BorderSide(color: colors.fieldBorder, width: components.formFieldBorder),
                    ),
                  ),
                ),
                SizedBox(width: components.panelCheckGap),
                Flexible(child: Text(label)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
