import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
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
      image: FileModel(url: json['image']),
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
      'title_lower': title.toLowerCase(),
      'image': image.url,
      'category': category.name,
      'teaser': teaser,
      'description': description,
      'link': link,
    };
  }

  @override
  MagazineModel copyWith({
    String? title,
    FileModel? image,
    MagazineCategory? category,
    String? teaser,
    String? description,
    String? link,
  }) {
    return MagazineModel(
      title: title ?? this.title,
      image: image ?? this.image,
      category: category ?? this.category,
      teaser: teaser ?? this.teaser,
      description: description ?? this.description,
      link: link ?? this.link,
    );
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
