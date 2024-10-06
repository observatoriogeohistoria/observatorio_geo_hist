import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  const CategoryModel({
    required this.key,
    required this.title,
    required this.backgroundImgUrl,
    required this.area,
    this.collaborateOption = false,
  });

  final String key;
  final String title;
  final String area;
  final String backgroundImgUrl;
  final bool collaborateOption;

  @override
  List<Object?> get props => [key, title, backgroundImgUrl, collaborateOption];

  factory CategoryModel.fromJson(
    Map<String, dynamic> json,
    String area,
  ) {
    return CategoryModel(
      key: json['key'] as String,
      title: json['title'] as String,
      area: area,
      backgroundImgUrl: json['backgroundImgUrl'] as String,
      collaborateOption: json['collaborateOption'] as bool,
    );
  }
}
