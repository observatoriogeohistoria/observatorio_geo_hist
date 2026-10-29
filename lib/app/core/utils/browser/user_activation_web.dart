import 'package:web/web.dart' as web;

/// The browser only allows playing with sound right after a click or key press.
/// Without this API, returns `false` so the video waits for a new click.
bool hasUserActivation() {
  try {
    return web.window.navigator.userActivation.isActive;
  } catch (_) {
    return false;
  }
}
