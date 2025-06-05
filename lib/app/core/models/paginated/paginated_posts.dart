import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

class PaginatedPosts {
  final List<PostModel> posts;
  final DocumentSnapshot? lastDocument;
  final bool hasMore;

  PaginatedPosts({
    required this.posts,
    required this.lastDocument,
    required this.hasMore,
  });
}
