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