enum UserRole {
  admin,
  editor,
  viewer;

  @override
  String toString() {
    switch (this) {
      case UserRole.admin:
        return 'ADMIN';
      case UserRole.editor:
        return 'EDITOR';
      case UserRole.viewer:
        return 'VIEWER';
    }
  }

  static UserRole fromString(String role) {
    switch (role) {
      case 'ADMIN':
        return UserRole.admin;
      case 'EDITOR':
        return UserRole.editor;
      case 'VIEWER':
        return UserRole.viewer;
      default:
        throw Exception('Invalid role');
    }
  }
}

class UserModel {
  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.role,
    this.isDeleted = false,
  });

  final String? id;
  final String name;
  final String email;
  final UserRole role;
  final bool isDeleted;

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
