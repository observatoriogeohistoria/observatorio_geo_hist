import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/labels/post_type_panel_labels.dart';

enum SidebarGroup {
  content('Conteúdo'),
  filesAndPeople('Arquivos e pessoas'),
  administration('Administração');

  const SidebarGroup(this.title);

  final String title;
}

enum SidebarItem {
  users,
  media,
  categories,
  posts,
  team,
  library;

  String get value {
    switch (this) {
      case SidebarItem.users:
        return 'usuarios';
      case SidebarItem.media:
        return 'midias';
      case SidebarItem.categories:
        return 'categorias';
      case SidebarItem.posts:
        return AppRoutes.publicationsSegment;
      case SidebarItem.team:
        return 'equipe';
      case SidebarItem.library:
        return AppRoutes.librarySegment;
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
        return 'Publicações';
      case SidebarItem.team:
        return 'Equipe';
      case SidebarItem.library:
        return 'Biblioteca';
    }
  }

  SidebarGroup get group {
    switch (this) {
      case SidebarItem.posts:
      case SidebarItem.categories:
      case SidebarItem.library:
        return SidebarGroup.content;
      case SidebarItem.media:
      case SidebarItem.team:
        return SidebarGroup.filesAndPeople;
      case SidebarItem.users:
        return SidebarGroup.administration;
    }
  }

  /// In posts the eyebrow is the section itself, because the title is the type.
  String get eyebrow => this == SidebarItem.posts ? title : group.title;

  IconData get icon {
    switch (this) {
      case SidebarItem.users:
        return Icons.person_outline;
      case SidebarItem.media:
        return Icons.image_outlined;
      case SidebarItem.categories:
        return Icons.sell_outlined;
      case SidebarItem.posts:
        return Icons.layers_outlined;
      case SidebarItem.team:
        return Icons.group_outlined;
      case SidebarItem.library:
        return Icons.menu_book_outlined;
    }
  }

  List<PostType> get subItems =>
      this == SidebarItem.posts ? PostTypePanelLabels.menuOrder : const [];

  static SidebarItem? fromString(String? value) {
    switch (value) {
      case 'usuarios':
        return SidebarItem.users;
      case 'midias':
        return SidebarItem.media;
      case 'categorias':
        return SidebarItem.categories;
      case AppRoutes.publicationsSegment:
        return SidebarItem.posts;
      case 'equipe':
        return SidebarItem.team;
      case AppRoutes.librarySegment:
        return SidebarItem.library;
      default:
        return null;
    }
  }
}
