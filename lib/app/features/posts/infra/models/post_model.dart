import 'package:equatable/equatable.dart';

class PostModel extends Equatable {
  const PostModel({
    required this.title,
    required this.subtitle,
    required this.markdownContent,
    required this.date,
    required this.imgUrl,
    required this.authors,
  });

  final String title;
  final String subtitle;
  final String markdownContent;
  final String date;
  final String imgUrl;
  final List<String> authors;

  @override
  List<Object?> get props => [
        title,
        subtitle,
        markdownContent,
        date,
        imgUrl,
        authors,
      ];

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      markdownContent: json['markdownContent'] as String,
      date: json['date'] as String,
      imgUrl: json['imgUrl'] as String,
      authors: (json['authors'] as List).map((author) => author as String).toList(),
    );
  }
}
