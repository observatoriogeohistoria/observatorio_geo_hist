import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

class MagazineModel extends PostBody {
  const MagazineModel({
    required super.title,
    required super.image,
    required this.category,
    required this.coverImage,
    this.teaser,
    required this.description,
    required this.link,
  });

  final MagazineCategory category;
  final String coverImage;
  final String? teaser;
  final String description;
  final String link;

  @override
  List<Object?> get props => [
        title,
        image,
        category,
        coverImage,
        teaser,
        description,
        link,
      ];

  factory MagazineModel.fromJson(Map<String, dynamic> json) {
    return MagazineModel(
      title: json['title'],
      image: json['image'],
      category: MagazineCategory.values.firstWhere((cat) => cat.portuguese == json['category']),
      coverImage: json['coverImage'],
      teaser: json['teaser'],
      description: json['description'],
      link: json['link'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category.portuguese,
      'coverImage': coverImage,
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
}
