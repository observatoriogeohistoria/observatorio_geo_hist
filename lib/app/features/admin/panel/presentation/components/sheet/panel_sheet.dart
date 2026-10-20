import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/form/form_error_alert.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

Future<void> showPanelSheet(BuildContext context, {required WidgetBuilder builder}) {
  final components = AppTheme.dimensions.components;
  final still = MediaQuery.disableAnimationsOf(context);

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Fechar sem salvar',
    barrierColor:
        AppTheme.colors.footerBackground.withValues(alpha: components.panelDrawerScrimOpacity),
    transitionDuration: still ? Duration.zero : components.panelSheetSlide,
    pageBuilder: (context, _, __) => builder(context),
    transitionBuilder: (context, animation, _, child) => SlideTransition(
      position: Tween(begin: const Offset(1, 0), end: Offset.zero)
          .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
      child: child,
    ),
  );
}

/// Um campo do formulário, na ordem da tela, para levar o foco ao primeiro com erro.
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

  /// Devolve a mensagem do erro, ou `null` quando salvou.
  final Future<String?> Function() onSave;

  /// Constrói os campos abaixo do painel, para lerem [isSavingOf] e chamarem [submitOf].
  final WidgetBuilder builder;
  final bool canSave;

  static bool isSavingOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_PanelSheetScope>()?.isSaving ?? false;

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

    setState(() {
      _saving = true;
      _submitted = true;
      _error = null;
    });

    final error = await widget.onSave();
    if (!mounted) return;

    // Se a sessão caiu e a tela mudou por baixo, a rota já não é a atual: fechar tiraria outra.
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
                            child: AbsorbPointer(
                              absorbing: _saving,
                              child: _PanelSheetScope(
                                isSaving: _saving,
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
                    divider,
                    _footer(isMobile),
                  ],
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
  const _PanelSheetScope({required this.isSaving, required this.submit, required super.child});

  final bool isSaving;
  final VoidCallback submit;

  @override
  bool updateShouldNotify(_PanelSheetScope oldWidget) => isSaving != oldWidget.isSaving;
}
