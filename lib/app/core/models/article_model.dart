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
      image: json['image'],
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
      'subtitle': subtitle,
      'authors': authors,
      'date': date,
      'image': image,
      'imageCaption': imageCaption,
      'content': content,
      'observation': observation,
    };
  }
}
