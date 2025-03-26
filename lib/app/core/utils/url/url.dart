import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

String getEncodedCurrentUrl() {
  return Uri.encodeComponent(Uri.base.toString());
}

String encodeUrlComponent(String url) {
  return Uri.encodeComponent(url);
}

Future<void> openUrl(String url) async {
  final Uri uri = Uri.parse(url);

  try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (kDebugMode) print('Could not launch $url');
    }
  } catch (e) {
    if (kDebugMode) print('Could not launch $url');
  }
}
