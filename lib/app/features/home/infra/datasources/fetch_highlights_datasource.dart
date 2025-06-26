import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:observatorio_geo_hist/app/core/infra/services/logger_service/logger_service.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

abstract class FetchHighlightsDatasource {
  Future<List<PostModel>> fetchHighlights(List<CategoryModel> categories);
}

class FetchHighlightsDatasourceImpl implements FetchHighlightsDatasource {
  final FirebaseFirestore _firestore;
  final LoggerService _loggerService;

  FetchHighlightsDatasourceImpl(this._firestore, this._loggerService);

  @override
  Future<List<PostModel>> fetchHighlights(List<CategoryModel> categories) async {
    try {
      Query query = _firestore
          .collectionGroup('category_posts')
          .where('isPublished', isEqualTo: true)
          .where('isHighlighted', isEqualTo: true);

      final snapshot = await query.get();

      final posts = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final fromJson = PostModel.fromJson(data);
        final category = categories.firstWhereOrNull((c) => c.key == fromJson.categoryId);

        return fromJson.copyWith(category: category);
      }).toList();

      return posts;
    } catch (exception) {
      _loggerService.error('Error fetching highlighted posts: $exception');
      rethrow;
    }
  }
}
