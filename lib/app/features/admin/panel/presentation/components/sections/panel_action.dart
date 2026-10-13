import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/models/states/crud_states.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/panel_counts_store.dart';

enum PanelAction { save, delete, publish, unpublish, highlight, unhighlight }

/// O store só diz que deu certo; quem disparou a ação guarda qual foi, para escolher o aviso
/// e saber se há um diálogo para fechar.
class PendingPanelAction {
  PanelAction? _action;

  void start(PanelAction action) => _action = action;

  PanelAction? take() {
    final action = _action;
    _action = null;
    return action;
  }
}

/// Só salvar vem de um diálogo; publicar, destacar e excluir partem da lista, sem nada para fechar.
void showPanelActionResult(
  BuildContext context, {
  required CrudState state,
  required PendingPanelAction pending,
  required Map<PanelAction, String> messages,
  required VoidCallback onForbidden,
}) {
  if (state is CrudErrorState) {
    pending.take();
    Messenger.showError(context, state.failure.message);
    if (state.failure is Forbidden) onForbidden();
    return;
  }

  if (state is! CrudSuccessState) return;

  final action = pending.take();
  if (action == null) return;

  if (action == PanelAction.save) Navigator.of(context, rootNavigator: true).pop();

  final message = messages[action];
  if (message != null) Messenger.showSuccess(context, message);

  if (action == PanelAction.save || action == PanelAction.delete) {
    PanelSetup.getIt<PanelCountsStore>().refresh();
  }
}
