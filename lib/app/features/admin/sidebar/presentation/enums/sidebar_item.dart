import 'package:flutter/material.dart';

enum SidebarItem {
  users,
  media,
  posts;

  String get title {
    switch (this) {
      case SidebarItem.users:
        return 'Usuários';
      case SidebarItem.media:
        return 'Mídias';
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
      case SidebarItem.posts:
        return Icons.post_add_outlined;
    }
  }

  static SidebarItem? fromString(String? value) {
    switch (value) {
      case 'usuarios':
        return SidebarItem.users;
      case 'media':
        return SidebarItem.media;
      case 'posts':
        return SidebarItem.posts;
      default:
        return null;
    }
  }
}
