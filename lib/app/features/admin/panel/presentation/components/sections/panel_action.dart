import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/models/states/crud_states.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/panel_counts_store.dart';

/// [save] comes from the side panel, which shows the error and closes by itself.
enum PanelAction { save, delete, publish, unpublish, highlight, unhighlight }

/// The store only says it succeeded; whoever triggered the action keeps which one it was, to pick the notice
/// and know whether to reload the counts.
class PendingPanelAction {
  PanelAction? _action;

  void start(PanelAction action) => _action = action;

  PanelAction? take() {
    final action = _action;
    _action = null;
    return action;
  }
}

/// An error opening the list ([isFirstPageLoad]) already shows in the error box, with no notice.
void showPanelActionResult(
  BuildContext context, {
  required CrudState state,
  required PendingPanelAction pending,
  required Map<PanelAction, String> messages,
  required VoidCallback onForbidden,
  bool isFirstPageLoad = false,
}) {
  if (state is CrudErrorState) {
    final action = pending.take();
    final shownInSheet = action == PanelAction.save;
    if (!shownInSheet && (action != null || !isFirstPageLoad)) {
      Messenger.showError(context, state.failure.message);
    }
    if (state.failure is Forbidden) onForbidden();
    return;
  }

  if (state is! CrudSuccessState) return;

  final action = pending.take();
  if (action == null) return;

  final message = messages[action];
  if (message != null) Messenger.showSuccess(context, message);

  if (action == PanelAction.save || action == PanelAction.delete) {
    PanelSetup.getIt<PanelCountsStore>().refresh();
  }
}

String? panelSaveError(CrudState state) => state is CrudErrorState ? state.failure.message : null;
