import 'dart:convert';
import 'dart:typed_data';

class ImageUtils {
  static bool isBase64(String value) {
    return value.startsWith("data:image/");
  }

  static bool isHttp(String value) {
    return value.startsWith("http");
  }

  static bool isAsset(String value) {
    return value.contains(RegExp(r"\.(jpg|jpeg|png|gif|bmp|webp)"));
  }

  static bool isSvg(String value) {
    return value.contains(RegExp(r"\.(svg|svg+xml)"));
  }

  static Uint8List decodeBase64(String base64String) {
    final RegExp regex = RegExp(r'data:image/[^;]+;base64,');
    base64String = base64String.replaceAll(regex, '');

    return base64.decode(base64String);
  }
}
