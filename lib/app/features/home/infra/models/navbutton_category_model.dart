import 'package:equatable/equatable.dart';

class NavButtonCategoryModel extends Equatable {
  const NavButtonCategoryModel({
    required this.key,
    required this.title,
    required this.backgroundImgUrl,
    this.collaborateOption = false,
  });

  final int key;
  final String title;
  final String backgroundImgUrl;
  final bool collaborateOption;

  @override
  List<Object?> get props => [key, title, backgroundImgUrl, collaborateOption];

  factory NavButtonCategoryModel.fromJson(Map<String, dynamic> json) {
    return NavButtonCategoryModel(
      key: json['key'] as int,
      title: json['title'] as String,
      backgroundImgUrl: json['backgroundImgUrl'] as String,
      collaborateOption: json['collaborateOption'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'title': title,
      'backgroundImgUrl': backgroundImgUrl,
      'collaborateOption': collaborateOption,
    };
  }

  NavButtonCategoryModel copyWith({
    int? key,
    String? title,
    String? backgroundImgUrl,
    bool? collaborateOption,
  }) {
    return NavButtonCategoryModel(
      key: key ?? this.key,
      title: title ?? this.title,
      backgroundImgUrl: backgroundImgUrl ?? this.backgroundImgUrl,
      collaborateOption: collaborateOption ?? this.collaborateOption,
    );
  }
}
