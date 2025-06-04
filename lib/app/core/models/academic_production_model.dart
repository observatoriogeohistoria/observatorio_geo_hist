import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

class AcademicProductionModel extends PostBody {
  const AcademicProductionModel({
    required super.title,
    required super.image,
    required this.category,
    required this.author,
    required this.advisor,
    required this.institution,
    required this.yearAndCity,
    required this.summary,
    required this.keywords,
    required this.link,
  });

  final AcademicProductionCategory category;
  final String author;
  final String advisor;
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
        institution,
        yearAndCity,
        summary,
        keywords,
        link,
      ];

  factory AcademicProductionModel.fromJson(Map<String, dynamic> json) {
    return AcademicProductionModel(
      title: json['title'],
      image: ImageModel(url: json['image']),
      category: AcademicProductionCategory.values.byName(json['category']),
      author: json['author'],
      advisor: json['advisor'],
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
      'category': category.name,
      'author': author,
      'advisor': advisor,
      'image': image.url,
      'institution': institution,
      'yearAndCity': yearAndCity,
      'summary': summary,
      'keywords': keywords,
      'link': link,
    };
  }

  @override
  AcademicProductionModel copyWith({
    String? title,
    ImageModel? image,
    AcademicProductionCategory? category,
    String? author,
    String? advisor,
    String? institution,
    String? yearAndCity,
    String? summary,
    String? keywords,
    String? link,
  }) {
    return AcademicProductionModel(
      title: title ?? this.title,
      image: image ?? this.image,
      category: category ?? this.category,
      author: author ?? this.author,
      advisor: advisor ?? this.advisor,
      institution: institution ?? this.institution,
      yearAndCity: yearAndCity ?? this.yearAndCity,
      summary: summary ?? this.summary,
      keywords: keywords ?? this.keywords,
      link: link ?? this.link,
    );
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

  static AcademicProductionCategory? fromPortuguese(String portuguese) {
    switch (portuguese) {
      case 'Artigo':
        return AcademicProductionCategory.article;
      case 'Dissertação':
        return AcademicProductionCategory.dissertation;
      case 'Monografia':
        return AcademicProductionCategory.monography;
      case 'Tese':
        return AcademicProductionCategory.thesis;
      default:
        return null;
    }
  }
}
