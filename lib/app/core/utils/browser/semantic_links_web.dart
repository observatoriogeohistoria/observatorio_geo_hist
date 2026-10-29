import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// The browser would follow the semantics `<a href>`s on its own, reloading the page.
/// The link's own `onTap` does the navigation.
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
