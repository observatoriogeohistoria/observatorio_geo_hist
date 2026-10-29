import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/form/form_error_alert.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_selection_area.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

Future<void> showPanelSheet(BuildContext context, {required WidgetBuilder builder}) {
  final components = AppTheme.dimensions.components;
  final still = MediaQuery.disableAnimationsOf(context);

  // This is showGeneralDialog's route, built here so Tab wraps around inside the panel instead
  // of escaping to the browser, as is the default on the web.
  return Navigator.of(context, rootNavigator: true).push(
    RawDialogRoute<void>(
      barrierDismissible: true,
      barrierLabel: 'Fechar sem salvar',
      barrierColor:
          AppTheme.colors.footerBackground.withValues(alpha: components.panelDrawerScrimOpacity),
      traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
      transitionDuration: still ? Duration.zero : components.panelSheetSlide,
      pageBuilder: (context, _, __) => AppSelectionArea(child: Builder(builder: builder)),
      transitionBuilder: (context, animation, _, child) => SlideTransition(
        position: Tween(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
        child: child,
      ),
    ),
  );
}

/// A form field, in screen order, to move focus to the first one with an error.
class PanelSheetField {
  const PanelSheetField(this.key, this.focusNode);

  final GlobalKey<FormFieldState> key;
  final FocusNode? focusNode;
}

class PanelSheet extends StatefulWidget {
  const PanelSheet({
    required this.title,
    required this.fields,
    required this.onSave,
    required this.builder,
    this.canSave = true,
    super.key,
  });

  final String title;
  final List<PanelSheetField> fields;

  /// Returns the error message, or `null` when saved.
  final Future<String?> Function() onSave;

  /// Builds the fields below the panel, so Enter calls [submitOf].
  final WidgetBuilder builder;
  final bool canSave;

  static void submitOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<_PanelSheetScope>()?.submit();

  @override
  State<PanelSheet> createState() => _PanelSheetState();
}

class _PanelSheetState extends State<PanelSheet> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  bool _saving = false;
  bool _submitted = false;
  String? _error;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _close() => Navigator.of(context).maybePop();

  Future<void> _submit() async {
    if (_saving || !widget.canSave) return;

    if (!_formKey.currentState!.validate()) {
      setState(() => _submitted = true);
      _focusFirstError();
      return;
    }

    final focused = FocusManager.instance.primaryFocus;
    setState(() {
      _saving = true;
      _submitted = true;
      _error = null;
    });

    final error = await widget.onSave();
    if (!mounted) return;

    // If the session dropped and the screen changed underneath, the route is no longer current: closing would pop another.
    final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
    if (error == null && isCurrent) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _saving = false;
      _error = error;
    });
    if (error != null && _scrollController.hasClients) _scrollController.jumpTo(0);
    if (focused != null && focused.context != null) focused.requestFocus();
  }

  void _focusFirstError() {
    for (final field in widget.fields) {
      if (!(field.key.currentState?.hasError ?? false)) continue;
      final fieldContext = field.key.currentContext;
      if (fieldContext != null) Scrollable.ensureVisible(fieldContext, alignment: 0.1);
      field.focusNode?.requestFocus();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final isMobile = ScreenUtils.isMobile(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final width = isMobile ? screenWidth : math.min(components.panelSheetWidth, screenWidth);
    final divider = Divider(
      height: AppTheme.dimensions.stroke.small,
      thickness: AppTheme.dimensions.stroke.small,
      color: colors.line,
    );
    final error = _error;

    return PopScope(
      canPop: !_saving,
      child: Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: width,
          height: double.infinity,
          child: Semantics(
            scopesRoute: true,
            namesRoute: true,
            explicitChildNodes: true,
            label: widget.title,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.page,
                boxShadow: AppTheme.dimensions.shadows.sheet,
              ),
              child: Material(
                type: MaterialType.transparency,
                // In reading order, Tab after "Salvar" skipped the "×" in the corner.
                child: FocusTraversalGroup(
                  policy: WidgetOrderTraversalPolicy(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _header(context),
                      divider,
                      Expanded(
                        child: Form(
                          key: _formKey,
                          autovalidateMode: _submitted
                              ? AutovalidateMode.onUserInteraction
                              : AutovalidateMode.disabled,
                          child: Scrollbar(
                            controller: _scrollController,
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              padding: EdgeInsets.all(components.panelSheetBodyPadding),
                              // Switching the fields to read-only breaks text input in the
                              // browser; taking focus off the body already prevents editing while saving.
                              child: ExcludeFocus(
                                excluding: _saving,
                                child: AbsorbPointer(
                                  absorbing: _saving,
                                  child: _PanelSheetScope(
                                    submit: _submit,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        if (error != null) ...[
                                          FormErrorAlert(message: error),
                                          SizedBox(height: components.formFieldGap),
                                        ],
                                        Builder(builder: widget.builder),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      divider,
                      _footer(isMobile),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: components.panelSheetPaddingH,
        vertical: components.panelSheetHeaderPaddingV,
      ),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                widget.title,
                style: AppTheme.typography.of(context).panelDialogTitle.copyWith(
                      color: colors.ink,
                    ),
              ),
            ),
          ),
          SizedBox(width: components.panelSheetHeaderGap),
          AppIconButton(
            icon: Icons.close,
            color: colors.ink,
            size: components.panelActionIcon,
            label: 'Fechar',
            tooltip: 'Fechar sem salvar',
            isDisabled: _saving,
            onPressed: _close,
          ),
        ],
      ),
    );
  }

  Widget _footer(bool isMobile) {
    final components = AppTheme.dimensions.components;

    final cancel = SecondaryButton.small(
      text: 'Cancelar',
      isDisabled: _saving,
      expand: isMobile,
      onPressed: _close,
    );
    final save = PrimaryButton.small(
      text: _saving ? 'Salvando…' : 'Salvar',
      isLoading: _saving,
      isDisabled: !widget.canSave,
      expand: isMobile,
      onPressed: _submit,
    );
    final gap = SizedBox(width: components.panelSheetFooterGap);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: components.panelSheetPaddingH,
        vertical: components.panelSheetFooterPaddingV,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children:
            isMobile ? [Expanded(child: cancel), gap, Expanded(child: save)] : [cancel, gap, save],
      ),
    );
  }
}

class _PanelSheetScope extends InheritedWidget {
  const _PanelSheetScope({required this.submit, required super.child});

  final VoidCallback submit;

  @override
  bool updateShouldNotify(_PanelSheetScope oldWidget) => false;
}
