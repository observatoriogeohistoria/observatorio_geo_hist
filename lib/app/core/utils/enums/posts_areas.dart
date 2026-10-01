enum PostsAreas {
  history,
  geography;

  static PostsAreas fromKey(String value) {
    switch (value) {
      case 'historia':
        return PostsAreas.history;
      case 'geografia':
        return PostsAreas.geography;
      default:
        throw Exception('Invalid value');
    }
  }

  /// Como [fromKey], mas `null` para chave inválida.
  static PostsAreas? tryFromKey(String value) {
    for (final area in PostsAreas.values) {
      if (area.key == value) return area;
    }
    return null;
  }

  String get key {
    switch (this) {
      case PostsAreas.history:
        return 'historia';
      case PostsAreas.geography:
        return 'geografia';
    }
  }

  static PostsAreas fromName(String value) {
    switch (value) {
      case 'História':
        return PostsAreas.history;
      case 'Geografia':
        return PostsAreas.geography;
      default:
        throw Exception('Invalid value');
    }
  }

  String get portuguese {
    switch (this) {
      case PostsAreas.history:
        return 'História';
      case PostsAreas.geography:
        return 'Geografia';
    }
  }
}
