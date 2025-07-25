import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
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

Future<Uint8List?> fetchUrl(String url) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) return response.bodyBytes;
  } catch (_) {
    return null;
  }

  return null;
}

String? getFileExtension(String? url) {
  String? extension;

  if (url != null && url.contains('.')) {
    // Remove query params/fragments
    final cleanUrl = url.split('?').first.split('#').first;
    // Pega a última parte após o ponto, se houver
    final parts = cleanUrl.split('.');
    if (parts.length > 1) {
      extension = parts.last;
    }
  }

  return extension;
}
