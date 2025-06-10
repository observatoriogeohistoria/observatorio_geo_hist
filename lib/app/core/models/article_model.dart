import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

class ArticleModel extends PostBody {
  const ArticleModel({
    required super.title,
    required super.image,
    required this.subtitle,
    required this.authors,
    required this.date,
    required this.imageCaption,
    required this.content,
    this.observation,
  });

  final String subtitle;
  final List<String> authors;
  final String date;
  final String imageCaption;
  final String content;
  final String? observation;

  @override
  List<Object?> get props => [
        title,
        image,
        subtitle,
        authors,
        date,
        imageCaption,
        content,
        observation,
      ];

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      title: json['title'],
      image: ImageModel(url: json['image']),
      subtitle: json['subtitle'],
      authors: List<String>.from(json['authors']),
      date: json['date'],
      imageCaption: json['imageCaption'],
      content: json['content'],
      observation: json['observation'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'title_lower': title.toLowerCase(),
      'subtitle': subtitle,
      'authors': authors,
      'date': date,
      'image': image.url,
      'imageCaption': imageCaption,
      'content': content,
      'observation': observation,
    };
  }

  @override
  ArticleModel copyWith({
    String? title,
    ImageModel? image,
    String? subtitle,
    List<String>? authors,
    String? date,
    String? imageCaption,
    String? content,
    String? observation,
  }) {
    return ArticleModel(
      title: title ?? this.title,
      image: image ?? this.image,
      subtitle: subtitle ?? this.subtitle,
      authors: authors ?? this.authors,
      date: date ?? this.date,
      imageCaption: imageCaption ?? this.imageCaption,
      content: content ?? this.content,
      observation: observation ?? this.observation,
    );
  }
}
