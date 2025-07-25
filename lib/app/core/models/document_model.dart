import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

class DocumentModel extends PostBody {
  const DocumentModel({
    required super.title,
    required super.image,
    required this.category,
    required this.description,
    required this.link,
  });

  final DocumentCategory category;
  final String description;
  final String link;

  @override
  List<Object?> get props => [
        title,
        image,
        category,
        description,
        link,
      ];

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      title: json['title'],
      image: FileModel(url: json['image']),
      category: DocumentCategory.values.byName(json['category']),
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
      'category': category.name,
      'description': description,
      'link': link,
    };
  }

  @override
  DocumentModel copyWith({
    String? title,
    FileModel? image,
    DocumentCategory? category,
    String? description,
    String? link,
  }) {
    return DocumentModel(
      title: title ?? this.title,
      image: image ?? this.image,
      category: category ?? this.category,
      description: description ?? this.description,
      link: link ?? this.link,
    );
  }
}

enum DocumentCategory {
  decree,
  deliberation,
  normativeDocument,
  law,
  provisionalMeasure,
  opinion,
  ordinance,
  regiment,
  regulation,
  resolution,
  summary,
  guide,
  website;

  String get portuguese {
    switch (this) {
      case DocumentCategory.decree:
        return 'Decreto';
      case DocumentCategory.deliberation:
        return 'Deliberação';
      case DocumentCategory.normativeDocument:
        return 'Documento Normativo';
      case DocumentCategory.law:
        return 'Lei';
      case DocumentCategory.provisionalMeasure:
        return 'Medida Provisória';
      case DocumentCategory.opinion:
        return 'Parecer';
      case DocumentCategory.ordinance:
        return 'Portaria';
      case DocumentCategory.regiment:
        return 'Regimento';
      case DocumentCategory.regulation:
        return 'Regulamento';
      case DocumentCategory.resolution:
        return 'Resolução';
      case DocumentCategory.summary:
        return 'Súmula';
      case DocumentCategory.guide:
        return 'Guia';
      case DocumentCategory.website:
        return 'Site';
    }
  }

  static DocumentCategory fromPortuguese(String portuguese) {
    switch (portuguese) {
      case 'Decreto':
        return DocumentCategory.decree;
      case 'Deliberação':
        return DocumentCategory.deliberation;
      case 'Documento Normativo':
        return DocumentCategory.normativeDocument;
      case 'Lei':
        return DocumentCategory.law;
      case 'Medida Provisória':
        return DocumentCategory.provisionalMeasure;
      case 'Parecer':
        return DocumentCategory.opinion;
      case 'Portaria':
        return DocumentCategory.ordinance;
      case 'Regimento':
        return DocumentCategory.regiment;
      case 'Regulamento':
        return DocumentCategory.regulation;
      case 'Resolução':
        return DocumentCategory.resolution;
      case 'Súmula':
        return DocumentCategory.summary;
      case 'Guia':
        return DocumentCategory.guide;
      case 'Site':
        return DocumentCategory.website;
      default:
        return DocumentCategory.decree;
    }
  }
}
