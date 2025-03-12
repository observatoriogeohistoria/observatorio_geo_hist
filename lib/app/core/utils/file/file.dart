import 'dart:convert';
import 'dart:typed_data';

bool isSvg(String base64Data) {
  if (base64Data.startsWith("data:image/svg+xml")) return true;
  return false;
}

Uint8List decodeBase64Image(String dataUri) {
  final base64Data = dataUri.split(",")[1];
  return base64Decode(base64Data);
}
