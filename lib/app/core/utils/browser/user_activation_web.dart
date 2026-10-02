import 'package:web/web.dart' as web;

/// O navegador só deixa tocar com som logo depois de um clique ou tecla.
/// Sem essa API, devolve `false` para o vídeo esperar um novo clique.
bool hasUserActivation() {
  try {
    return web.window.navigator.userActivation.isActive;
  } catch (_) {
    return false;
  }
}
