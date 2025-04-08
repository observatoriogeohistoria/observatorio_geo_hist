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
      image: json['image'],
      category: DocumentCategory.values.firstWhere((cat) => cat.portuguese == json['category']),
      description: json['description'],
      link: json['link'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'image': image,
      'category': category.portuguese,
      'description': description,
      'link': link,
    };
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
}
