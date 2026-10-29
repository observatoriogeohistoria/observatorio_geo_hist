import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/state_message_box.dart';

class StateErrorBox extends StatelessWidget {
  const StateErrorBox({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return StateMessageBox(
      icon: Icons.close,
      tone: StateMessageTone.error,
      title: 'Não foi possível carregar',
      message: 'Verifique sua conexão e tente novamente.',
      action: PrimaryButton.small(text: 'Tentar de novo', onPressed: onRetry),
    );
  }
}
