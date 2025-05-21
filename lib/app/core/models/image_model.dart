import 'dart:typed_data';

class ImageModel {
  ImageModel({
    this.url,
    this.bytes,
    this.name,
  });

  final String? url;
  final Uint8List? bytes;
  final String? name;

  bool get isNull => url == null && bytes == null && name == null;

  ImageModel copyWith({
    String? url,
    Uint8List? bytes,
    String? name,
  }) =>
      ImageModel(
        url: url ?? this.url,
        bytes: bytes ?? this.bytes,
        name: name ?? this.name,
      );
}
