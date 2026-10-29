import 'dart:js_interop';

import 'package:web/web.dart' as web;

web.EventListener? _listener;

void setLeaveWarning(bool enabled) {
  final listener = _listener;
  if (enabled == (listener != null)) return;

  if (listener != null) {
    web.window.removeEventListener('beforeunload', listener);
    _listener = null;
    return;
  }

  final added = ((web.BeforeUnloadEvent event) {
    event.preventDefault();
    event.returnValue = '';
  }).toJS;
  web.window.addEventListener('beforeunload', added);
  _listener = added;
}

String? browserLocation() => '${web.window.location.pathname}${web.window.location.search}';
