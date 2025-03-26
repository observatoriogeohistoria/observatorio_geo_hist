import 'dart:typed_data';

class MediaModel {
  MediaModel({
    this.id,
    required this.name,
    required this.extension,
    this.bytes,
    this.url,
  });

  final String? id;
  final String name;
  final String extension;
  final Uint8List? bytes;
  final String? url;

  MediaModel copyWith({
    String? id,
    String? name,
    String? extension,
    Uint8List? bytes,
    String? url,
  }) {
    return MediaModel(
      id: id ?? this.id,
      name: name ?? this.name,
      extension: extension ?? this.extension,
      bytes: bytes ?? this.bytes,
      url: url ?? this.url,
    );
  }
}
