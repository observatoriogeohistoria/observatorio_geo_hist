import 'package:flutter/material.dart';

enum SidebarItem {
  users,
  media,
  categories,
  posts;

  String get value {
    switch (this) {
      case SidebarItem.users:
        return 'usuarios';
      case SidebarItem.media:
        return 'mídias';
      case SidebarItem.categories:
        return 'categorias';
      case SidebarItem.posts:
        return 'posts';
    }
  }

  String get title {
    switch (this) {
      case SidebarItem.users:
        return 'Usuários';
      case SidebarItem.media:
        return 'Mídias';
      case SidebarItem.categories:
        return 'Categorias';
      case SidebarItem.posts:
        return 'Posts';
    }
  }

  IconData get icon {
    switch (this) {
      case SidebarItem.users:
        return Icons.people;
      case SidebarItem.media:
        return Icons.perm_media;
      case SidebarItem.categories:
        return Icons.category;
      case SidebarItem.posts:
        return Icons.post_add_outlined;
    }
  }

  static SidebarItem? fromString(String? value) {
    switch (value) {
      case 'usuarios':
        return SidebarItem.users;
      case 'mídias':
        return SidebarItem.media;
      case 'categorias':
        return SidebarItem.categories;
      case 'posts':
        return SidebarItem.posts;
      default:
        return null;
    }
  }
}
