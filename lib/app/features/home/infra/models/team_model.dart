import 'package:equatable/equatable.dart';

class TeamMemberModel extends Equatable {
  const TeamMemberModel({
    required this.id,
    required this.name,
    required this.role,
    required this.description,
    required this.lattesUrl,
  });

  final String id;
  final String name;
  final String role;
  final String description;
  final String lattesUrl;

  @override
  List<Object?> get props => [id, name, role, description, lattesUrl];

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      description: json['description'] as String,
      lattesUrl: json['lattesUrl'] as String,
    );
  }
}
