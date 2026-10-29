import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/breadcrumbs.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/page_header.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_page_scaffold.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/stores/fetch_categories_store.dart';
import 'package:observatorio_geo_hist/app/features/posts/posts_setup.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/listing/posts_listing.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/stores/posts_listing_store.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/stores/states/posts_listing_states.dart';

class AllPostsPage extends StatefulWidget {
  const AllPostsPage({super.key});

  @override
  State<AllPostsPage> createState() => _AllPostsPageState();
}

class _AllPostsPageState extends State<AllPostsPage> {
  late final _store = PostsSetup.getIt<PostsListingStore>();

  @override
  void initState() {
    super.initState();
    PostsSetup.getIt<FetchCategoriesStore>().setSelectedCategory(null);
    _store.load(PostsListingScope.all());
  }

  String? _routeFor(PostModel post) {
    final id = post.id;
    if (id == null || post.areas.isEmpty) return null;
    return AppRoutes.post(post.areas.first.key, post.categoryId, id);
  }

  @override
  Widget build(BuildContext context) {
    return ReadingPageScaffold(
      header: const PageHeader(
        breadcrumbs: [
          BreadcrumbItem('Início', route: AppRoutes.root),
          BreadcrumbItem('Publicações'),
        ],
        title: 'Todas as publicações',
        lead: 'Artigos, livros, filmes, eventos e outros materiais de todas as categorias de '
            'História e Geografia.',
      ),
      body: PostsListing(
        store: _store,
        routeFor: _routeFor,
        emptyTitle: 'Ainda não há publicações',
        emptyMessage: 'Volte em breve.',
      ),
    );
  }
}
