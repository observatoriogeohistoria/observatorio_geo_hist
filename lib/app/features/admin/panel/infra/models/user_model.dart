import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_permissions.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_role.dart';

class UserModel {
  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.role,
    this.isDeleted = false,
  }) {
    permissions = UserPermissions(
      canViewUsersSection: isAdmin,
      canEditUsersSection: isAdmin,
      canViewMediaSection: true,
      canEditMediaSection: isAdmin || isEditor,
      canViewCategoriesSection: true,
      canEditCategoriesSection: isAdmin || isEditor,
      canViewPostsSection: true,
      canEditPostsSection: isAdmin || isEditor,
      canViewTeamSection: true,
      canEditTeamSection: isAdmin || isEditor,
    );
  }

  final String? id;
  final String name;
  final String email;
  final UserRole role;
  final bool isDeleted;

  late final UserPermissions permissions;

  bool get isAdmin => role == UserRole.admin;
  bool get isEditor => role == UserRole.editor;
  bool get isViewer => role == UserRole.viewer;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: UserRole.fromString(json['role']),
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.toString(),
      'isDeleted': isDeleted,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    bool? isDeleted,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
