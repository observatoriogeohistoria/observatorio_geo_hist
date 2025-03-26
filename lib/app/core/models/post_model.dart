import 'package:equatable/equatable.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';

class PostModel extends Equatable {
  const PostModel({
    required this.title,
    required this.subtitle,
    required this.areas,
    required this.categoryKey,
    required this.markdownContent,
    required this.date,
    required this.imgUrl,
    required this.authors,
    this.id,
    this.category,
    this.imgCaption,
    this.observation,
    this.createdAt,
    this.updatedAt,
    this.isPublished = false,
    this.isHighlighted = false,
  });

  final String title;
  final String subtitle;
  final List<PostsAreas> areas;
  final String categoryKey;
  final String markdownContent;
  final String date;
  final String imgUrl;
  final List<String> authors;

  final String? id;
  final CategoryModel? category;
  final String? imgCaption;
  final String? observation;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final bool isPublished;
  final bool isHighlighted;

  @override
  List<Object?> get props => [
        title,
        subtitle,
        areas,
        categoryKey,
        markdownContent,
        date,
        imgUrl,
        authors,
        id,
        category,
        imgCaption,
        observation,
        createdAt,
        updatedAt,
        isPublished,
        isHighlighted,
      ];

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      areas: (json['areas'] as List).map((area) => PostsAreas.fromKey(area as String)).toList(),
      categoryKey: json['category'],
      markdownContent: json['markdownContent'] as String,
      date: json['date'] as String,
      imgUrl: json['imgUrl'] as String,
      authors: (json['authors'] as List).map((author) => author as String).toList(),
      id: json['id'] as String,
      imgCaption: json['imgCaption'] as String?,
      observation: json['observation'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      isPublished: json['isPublished'] as bool,
      isHighlighted: json['isHighlighted'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'areas': areas.map((area) => area.key).toList(),
      'category': categoryKey,
      'markdownContent': markdownContent,
      'date': date,
      'imgUrl': imgUrl,
      'authors': authors,
      'id': id,
      'imgCaption': imgCaption,
      'observation': observation,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isPublished': isPublished,
      'isHighlighted': isHighlighted,
    };
  }

  PostModel copyWith({
    String? title,
    String? subtitle,
    List<PostsAreas>? areas,
    String? categoryKey,
    String? markdownContent,
    String? date,
    String? imgUrl,
    List<String>? authors,
    String? id,
    CategoryModel? category,
    String? imgCaption,
    String? observation,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPublished,
    bool? isHighlighted,
  }) {
    return PostModel(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      areas: areas ?? this.areas,
      categoryKey: categoryKey ?? this.categoryKey,
      markdownContent: markdownContent ?? this.markdownContent,
      date: date ?? this.date,
      imgUrl: imgUrl ?? this.imgUrl,
      authors: authors ?? this.authors,
      id: id ?? this.id,
      category: category ?? this.category,
      imgCaption: imgCaption ?? this.imgCaption,
      observation: observation ?? this.observation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublished: isPublished ?? this.isPublished,
      isHighlighted: isHighlighted ?? this.isHighlighted,
    );
  }
}
