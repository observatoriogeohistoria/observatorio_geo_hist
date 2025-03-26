import 'package:equatable/equatable.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';

class CategoryModel extends Equatable {
  const CategoryModel({
    required this.key,
    required this.title,
    required this.description,
    required this.backgroundImgUrl,
    required this.areas,
    this.hasCollaborateOption = false,
    this.numberOfPosts = 0,
  });

  final String key;
  final String title;
  final String description;
  final List<PostsAreas> areas;
  final String backgroundImgUrl;
  final bool hasCollaborateOption;
  final int numberOfPosts;

  @override
  List<Object?> get props => [
        key,
        title,
        description,
        areas,
        backgroundImgUrl,
        hasCollaborateOption,
        numberOfPosts,
      ];

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      key: json['key'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      areas: (json['areas'] as List).map((area) => PostsAreas.fromKey(area as String)).toList(),
      backgroundImgUrl: json['backgroundImgUrl'] as String,
      hasCollaborateOption: json['hasCollaborateOption'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'title': title,
      'description': description,
      'areas': areas.map((area) => area.key).toList(),
      'backgroundImgUrl': backgroundImgUrl,
      'hasCollaborateOption': hasCollaborateOption,
    };
  }

  CategoryModel copyWith({
    String? key,
    String? title,
    String? description,
    List<PostsAreas>? areas,
    String? backgroundImgUrl,
    bool? hasCollaborateOption,
    int? numberOfPosts,
  }) {
    return CategoryModel(
      key: key ?? this.key,
      title: title ?? this.title,
      description: description ?? this.description,
      backgroundImgUrl: backgroundImgUrl ?? this.backgroundImgUrl,
      areas: areas ?? this.areas,
      hasCollaborateOption: hasCollaborateOption ?? this.hasCollaborateOption,
      numberOfPosts: numberOfPosts ?? this.numberOfPosts,
    );
  }
}
