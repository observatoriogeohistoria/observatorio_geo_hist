import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/breadcrumbs.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';

class PostBreadcrumbs extends StatelessWidget {
  const PostBreadcrumbs({
    super.key,
    required this.area,
    required this.category,
    required this.typeLabel,
  });

  final PostsAreas area;
  final CategoryModel category;
  final String typeLabel;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Breadcrumbs(
        items: [
          const BreadcrumbItem('Início', route: AppRoutes.root),
          BreadcrumbItem(area.portuguese),
          BreadcrumbItem(category.title, route: AppRoutes.category(area.key, category.key)),
          BreadcrumbItem(typeLabel),
        ],
      ),
    );
  }
}
