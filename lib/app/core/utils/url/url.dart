import 'dart:js' as js;

String getEncodedCurrentUrl() {
  return Uri.encodeComponent(js.context['window'].location.href);
}

String encodeUrlComponent(String url) {
  return Uri.encodeComponent(url);
}

String openUrl(String url) {
  return js.context['window'].open(url, '_blank');
}
