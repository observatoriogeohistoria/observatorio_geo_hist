import 'package:web/web.dart' as web;

/// Diz se o clique ou a tecla mais recente da pessoa ainda vale como
/// "ativação" para o navegador, que só deixa tocar som logo depois de uma
/// interação (`navigator.userActivation.isActive`). Em navegador sem essa API,
/// devolve `false`, para o vídeo esperar um novo clique em vez de falhar.
bool hasUserActivation() {
  try {
    return web.window.navigator.userActivation.isActive;
  } catch (_) {
    return false;
  }
}
