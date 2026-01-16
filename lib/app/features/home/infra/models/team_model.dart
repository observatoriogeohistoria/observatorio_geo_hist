import 'package:equatable/equatable.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';

class TeamMemberModel extends Equatable {
  const TeamMemberModel({
    this.id,
    required this.name,
    required this.role,
    required this.description,
    required this.lattesUrl,
    required this.image,
  });

  final String? id;
  final String name;
  final String role;
  final String? description;
  final String? lattesUrl;
  final FileModel? image;

  @override
  List<Object?> get props => [id, name, role, description, lattesUrl];

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      description: json['description'] as String,
      lattesUrl: json['lattesUrl'] as String,
      image: FileModel(url: json['image']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'description': description,
      'lattesUrl': lattesUrl,
      'image': image?.url,
    };
  }

  TeamMemberModel copyWith({
    String? id,
    String? name,
    String? role,
    String? description,
    String? lattesUrl,
    FileModel? image,
  }) {
    return TeamMemberModel(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      description: description ?? this.description,
      lattesUrl: lattesUrl ?? this.lattesUrl,
      image: image ?? this.image,
    );
  }
}
