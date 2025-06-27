import 'package:equatable/equatable.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';

class CategoryModel extends Equatable {
  const CategoryModel({
    required this.key,
    required this.title,
    required this.description,
    required this.backgroundImg,
    required this.areas,
    this.hasCollaborateOption = false,
    this.numberOfPosts = 0,
    this.postsTypes = const [],
  });

  final String key;
  final String title;
  final String description;
  final List<PostsAreas> areas;
  final ImageModel backgroundImg;
  final bool hasCollaborateOption;

  final int numberOfPosts;
  final List<PostType> postsTypes;

  @override
  List<Object?> get props => [
        key,
        title,
        description,
        areas,
        backgroundImg,
        hasCollaborateOption,
        numberOfPosts,
        postsTypes,
      ];

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      key: json['key'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      areas: (json['areas'] as List).map((area) => PostsAreas.fromKey(area as String)).toList(),
      backgroundImg: ImageModel(url: json['backgroundImgUrl'] as String),
      hasCollaborateOption: json['hasCollaborateOption'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'title': title,
      'title_lower': title.toLowerCase(),
      'description': description,
      'areas': areas.map((area) => area.key).toList(),
      'backgroundImgUrl': backgroundImg.url,
      'hasCollaborateOption': hasCollaborateOption,
    };
  }

  CategoryModel copyWith({
    String? key,
    String? title,
    String? description,
    List<PostsAreas>? areas,
    ImageModel? backgroundImgUrl,
    bool? hasCollaborateOption,
    int? numberOfPosts,
    List<PostType>? postsTypes,
  }) {
    return CategoryModel(
      key: key ?? this.key,
      title: title ?? this.title,
      description: description ?? this.description,
      backgroundImg: backgroundImgUrl ?? backgroundImg,
      areas: areas ?? this.areas,
      hasCollaborateOption: hasCollaborateOption ?? this.hasCollaborateOption,
      numberOfPosts: numberOfPosts ?? this.numberOfPosts,
      postsTypes: postsTypes ?? this.postsTypes,
    );
  }
}
