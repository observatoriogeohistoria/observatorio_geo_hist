import 'package:equatable/equatable.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';

class CategoryModel extends Equatable {
  const CategoryModel({
    required this.key,
    required this.title,
    required this.description,
    required this.backgroundImgUrl,
    required this.area,
    this.collaborateOption = false,
  });

  final String key;
  final String title;
  final String description;
  final PostsAreas area;
  final String backgroundImgUrl;
  final bool collaborateOption;

  @override
  List<Object?> get props => [
        key,
        title,
        description,
        area,
        backgroundImgUrl,
        collaborateOption,
      ];

  factory CategoryModel.fromJson(
    Map<String, dynamic> json,
    String area,
  ) {
    return CategoryModel(
      key: json['key'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      area: PostsAreas.fromKey(area),
      backgroundImgUrl: json['backgroundImgUrl'] as String,
      collaborateOption: json['collaborateOption'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'title': title,
      'description': description,
      'area': area.key,
      'backgroundImgUrl': backgroundImgUrl,
      'collaborateOption': collaborateOption,
    };
  }

  CategoryModel copyWith({
    String? key,
    String? title,
    String? description,
    PostsAreas? area,
    String? backgroundImgUrl,
    bool? collaborateOption,
  }) {
    return CategoryModel(
      key: key ?? this.key,
      title: title ?? this.title,
      description: description ?? this.description,
      backgroundImgUrl: backgroundImgUrl ?? this.backgroundImgUrl,
      area: area ?? this.area,
      collaborateOption: collaborateOption ?? this.collaborateOption,
    );
  }
}
