import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

class AcademicProductionModel extends PostBody {
  const AcademicProductionModel({
    required super.title,
    required super.image,
    required this.category,
    required this.author,
    required this.advisor,
    required this.imageCaption,
    required this.institution,
    required this.yearAndCity,
    required this.summary,
    required this.keywords,
    required this.link,
  });

  final AcademicProductionCategory category;
  final String author;
  final String advisor;
  final String imageCaption;
  final String institution;
  final String yearAndCity;
  final String summary;
  final String keywords;
  final String link;

  @override
  List<Object?> get props => [
        title,
        image,
        category,
        author,
        advisor,
        imageCaption,
        institution,
        yearAndCity,
        summary,
        keywords,
        link,
      ];

  factory AcademicProductionModel.fromJson(Map<String, dynamic> json) {
    return AcademicProductionModel(
      title: json['title'],
      image: json['image'],
      category: AcademicProductionCategory.values
          .firstWhere((category) => category.portuguese == json['category']),
      author: json['author'],
      advisor: json['advisor'],
      imageCaption: json['imageCaption'],
      institution: json['institution'],
      yearAndCity: json['yearAndCity'],
      summary: json['summary'],
      keywords: json['keywords'],
      link: json['link'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category.portuguese,
      'author': author,
      'advisor': advisor,
      'image': image,
      'imageCaption': imageCaption,
      'institution': institution,
      'yearAndCity': yearAndCity,
      'summary': summary,
      'keywords': keywords,
      'link': link,
    };
  }
}

enum AcademicProductionCategory {
  article,
  dissertation,
  monography,
  thesis;

  String get portuguese {
    switch (this) {
      case AcademicProductionCategory.article:
        return 'Artigo';
      case AcademicProductionCategory.dissertation:
        return 'Dissertação';
      case AcademicProductionCategory.monography:
        return 'Monografia';
      case AcademicProductionCategory.thesis:
        return 'Tese';
    }
  }
}
