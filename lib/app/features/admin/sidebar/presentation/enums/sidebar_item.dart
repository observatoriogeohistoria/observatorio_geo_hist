import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

enum SidebarItem {
  users,
  media,
  categories,
  posts,
  team;

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
      case SidebarItem.team:
        return 'equipe';
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
      case SidebarItem.team:
        return 'Equipe';
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
      case SidebarItem.team:
        return Icons.workspaces;
    }
  }

  List<PostType> get subItems {
    switch (this) {
      case SidebarItem.users:
        return [];
      case SidebarItem.media:
        return [];
      case SidebarItem.categories:
        return [];
      case SidebarItem.posts:
        final sorted = PostType.values.toList();
        sorted.sort((a, b) => a.portuguese.compareTo(b.portuguese));

        return sorted;
      case SidebarItem.team:
        return [];
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
      case 'equipe':
        return SidebarItem.team;
      default:
        return null;
    }
  }
}
