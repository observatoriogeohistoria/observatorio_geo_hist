import 'dart:typed_data';

class FileModel {
  FileModel({
    this.url,
    this.bytes,
    this.name,
    this.extension,
  });

  final String? url;
  final Uint8List? bytes;
  final String? name;
  final String? extension;

  bool get isNull => url == null && bytes == null && name == null && extension == null;

  FileModel copyWith({
    String? url,
    Uint8List? bytes,
    String? name,
    String? extension,
  }) =>
      FileModel(
        url: url ?? this.url,
        bytes: bytes ?? this.bytes,
        name: name ?? this.name,
        extension: extension ?? this.extension,
      );
}
