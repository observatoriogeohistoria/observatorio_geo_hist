import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

class ArtistModel extends PostBody {
  const ArtistModel({
    required super.title,
    required super.image,
    required this.description,
    required this.link,
  });

  final String description;
  final String link;

  @override
  List<Object?> get props => [
        title,
        image,
        description,
        link,
      ];

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      title: json['title'],
      image: ImageModel(url: json['image']),
      description: json['description'],
      link: json['link'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'image': image.url,
      'description': description,
      'link': link,
    };
  }

  @override
  ArtistModel copyWith({
    String? title,
    ImageModel? image,
    String? description,
    String? link,
  }) {
    return ArtistModel(
      title: title ?? this.title,
      image: image ?? this.image,
      description: description ?? this.description,
      link: link ?? this.link,
    );
  }
}
