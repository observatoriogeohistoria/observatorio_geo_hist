import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;

import 'native_share_stub.dart' show NativeShareResult;

export 'native_share_stub.dart' show NativeShareResult;

bool canNativeShare() {
  try {
    final navigator = web.window.navigator;
    final object = navigator as JSObject;
    if (!object.has('share')) return false;
    if (!object.has('canShare')) return true;
    return navigator.canShare(web.ShareData(title: web.document.title, url: web.window.location.href));
  } catch (_) {
    return false;
  }
}

/// Precisa ser chamada direto do toque, sem `await` antes, ou o navegador recusa.
Future<NativeShareResult> nativeShare({required String title, required String url}) async {
  try {
    await web.window.navigator.share(web.ShareData(title: title, url: url)).toDart;
    return NativeShareResult.shared;
  } catch (error) {
    // A pessoa fechou a folha: o navegador rejeita com `AbortError`.
    if (error.toString().contains('AbortError')) return NativeShareResult.cancelled;
    return NativeShareResult.failed;
  }
}
