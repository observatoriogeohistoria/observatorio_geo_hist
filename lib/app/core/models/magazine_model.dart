import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

class MagazineModel extends PostBody {
  const MagazineModel({
    required super.title,
    required super.image,
    required this.category,
    required this.description,
    required this.link,
    this.teaser,
  });

  final MagazineCategory category;
  final String? teaser;
  final String description;
  final String link;

  @override
  List<Object?> get props => [
        title,
        image,
        category,
        teaser,
        description,
        link,
      ];

  factory MagazineModel.fromJson(Map<String, dynamic> json) {
    return MagazineModel(
      title: json['title'],
      image: json['image'],
      category: MagazineCategory.values.byName(json['category']),
      teaser: json['teaser'],
      description: json['description'],
      link: json['link'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category.name,
      'teaser': teaser,
      'description': description,
      'link': link,
    };
  }
}

enum MagazineCategory {
  magazine,
  dossier;

  String get portuguese {
    switch (this) {
      case MagazineCategory.magazine:
        return 'Revista';
      case MagazineCategory.dossier:
        return 'Dossiê';
    }
  }

  static MagazineCategory? fromPortuguese(String portuguese) {
    switch (portuguese) {
      case 'Revista':
        return MagazineCategory.magazine;
      case 'Dossiê':
        return MagazineCategory.dossier;
      default:
        return null;
    }
  }
}
