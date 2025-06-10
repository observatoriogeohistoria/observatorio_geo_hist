import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

class PodcastModel extends PostBody {
  const PodcastModel({
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

  factory PodcastModel.fromJson(Map<String, dynamic> json) {
    return PodcastModel(
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
      'title_lower': title.toLowerCase(),
      'image': image.url,
      'description': description,
      'link': link,
    };
  }

  @override
  PodcastModel copyWith({
    String? title,
    ImageModel? image,
    String? description,
    String? link,
  }) {
    return PodcastModel(
      title: title ?? this.title,
      image: image ?? this.image,
      description: description ?? this.description,
      link: link ?? this.link,
    );
  }
}
