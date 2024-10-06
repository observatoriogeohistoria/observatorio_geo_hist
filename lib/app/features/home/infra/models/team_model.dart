import 'package:equatable/equatable.dart';

class TeamMemberModel extends Equatable {
  const TeamMemberModel({
    required this.name,
    required this.role,
    required this.description,
    required this.lattesUrl,
  });

  final String name;
  final String role;
  final String description;
  final String lattesUrl;

  @override
  List<Object?> get props => [name, role, description, lattesUrl];

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
      name: json['name'] as String,
      role: json['role'] as String,
      description: json['description'] as String,
      lattesUrl: json['lattesUrl'] as String,
    );
  }
}
