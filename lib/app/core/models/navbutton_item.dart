import 'package:equatable/equatable.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';

class NavButtonItem extends Equatable {
  const NavButtonItem({
    required this.title,
    this.route,
    this.area,
    this.category,
    this.options,
  });

  final String title;
  final String? route;
  final PostsAreas? area;
  final CategoryModel? category;
  final List<NavButtonItem>? options;

  @override
  List<Object?> get props => [title, route, area, category, options];
}
