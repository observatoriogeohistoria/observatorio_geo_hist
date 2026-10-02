import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// O navegador seguiria sozinho os `<a href>` da semântica, recarregando a página.
/// Quem navega é o `onTap` do próprio link.
void preventSemanticLinkNavigation() {
  web.document.addEventListener(
    'click',
    (web.Event event) {
      final target = event.target;
      if (target == null || !target.isA<web.Element>()) return;
      if ((target as web.Element).closest('flt-semantics-host a[href]') != null) {
        event.preventDefault();
      }
    }.toJS,
    true.toJS,
  );
}
