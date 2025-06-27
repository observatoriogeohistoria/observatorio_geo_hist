import 'package:observatorio_geo_hist/app/core/models/category_model.dart';

class CategoriesByArea {
  CategoriesByArea({
    this.history = const [],
    this.geography = const [],
  });

  final List<CategoryModel> history;
  final List<CategoryModel> geography;
}
