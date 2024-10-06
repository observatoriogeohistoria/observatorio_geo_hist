import 'package:equatable/equatable.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';

class NavButtonItem extends Equatable {
  const NavButtonItem({
    required this.title,
    this.route,
    this.category,
    this.options,
  });

  final String title;
  final String? route;
  final CategoryModel? category;
  final List<NavButtonItem>? options;

  @override
  List<Object?> get props => [title, route, category, options];
}
