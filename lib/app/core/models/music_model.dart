import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

class MusicModel extends PostBody {
  const MusicModel({
    required super.title,
    required super.image,
    required this.artistName,
    required this.description,
    this.lyrics,
    required this.link,
  });

  final String artistName;
  final String description;
  final String? lyrics;
  final String link;

  @override
  List<Object?> get props => [
        title,
        image,
        artistName,
        description,
        lyrics,
        link,
      ];

  factory MusicModel.fromJson(Map<String, dynamic> json) {
    return MusicModel(
      title: json['title'],
      image: FileModel(url: json['image']),
      artistName: json['artistName'],
      description: json['description'],
      lyrics: json['lyrics'],
      link: json['link'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'title_lower': title.toLowerCase(),
      'image': image.url,
      'artistName': artistName,
      'description': description,
      'lyrics': lyrics,
      'link': link,
    };
  }

  @override
  MusicModel copyWith({
    String? title,
    FileModel? image,
    String? artistName,
    String? description,
    String? lyrics,
    String? link,
  }) {
    return MusicModel(
      title: title ?? this.title,
      image: image ?? this.image,
      artistName: artistName ?? this.artistName,
      description: description ?? this.description,
      lyrics: lyrics ?? this.lyrics,
      link: link ?? this.link,
    );
  }
}
