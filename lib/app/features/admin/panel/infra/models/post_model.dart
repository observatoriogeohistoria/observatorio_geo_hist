import 'package:equatable/equatable.dart';

class PostModel extends Equatable {
  const PostModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.area,
    required this.category,
    required this.markdownContent,
    required this.date,
    required this.imgUrl,
    required this.authors,
    this.published = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final String area;
  final String category;
  final String markdownContent;
  final String date;
  final String imgUrl;
  final List<String> authors;
  final bool published;

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        area,
        category,
        markdownContent,
        date,
        imgUrl,
        authors,
        published,
      ];

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      area: json['area'] as String,
      category: json['category'] as String,
      markdownContent: json['markdownContent'] as String,
      date: json['date'] as String,
      imgUrl: json['imgUrl'] as String,
      authors: (json['authors'] as List).map((author) => author as String).toList(),
      published: json['published'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'area': area,
      'category': category,
      'markdownContent': markdownContent,
      'date': date,
      'imgUrl': imgUrl,
      'authors': authors,
      'published': published,
    };
  }

  PostModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? area,
    String? category,
    String? markdownContent,
    String? date,
    String? imgUrl,
    List<String>? authors,
    bool? published,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      area: area ?? this.area,
      category: category ?? this.category,
      markdownContent: markdownContent ?? this.markdownContent,
      date: date ?? this.date,
      imgUrl: imgUrl ?? this.imgUrl,
      authors: authors ?? this.authors,
      published: published ?? this.published,
    );
  }
}
