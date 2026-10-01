import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/state_error_box.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_page_scaffold.dart';
import 'package:observatorio_geo_hist/app/core/components/support/support.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/stores/fetch_categories_store.dart';
import 'package:observatorio_geo_hist/app/core/stores/states/fetch_categories_states.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/home/home_setup.dart';
import 'package:observatorio_geo_hist/app/features/posts/posts_setup.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/article_body.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/post_page_skeleton.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/post_type_content.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/related_posts_section.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/stores/post_detail_store.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/stores/states/post_detail_states.dart';
import 'package:observatorio_geo_hist/app/router/page_not_found.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Página do post (spec 012): conteúdo do tipo, Leia também (artigo), Apoio e
/// rodapé, com esqueleto, não encontrado (404) e erro com "Tentar de novo".
class PostDetailedPage extends StatefulWidget {
  const PostDetailedPage({
    required this.area,
    required this.categoryKey,
    required this.postId,
    super.key,
  });

  final PostsAreas area;
  final String categoryKey;
  final String postId;

  @override
  State<PostDetailedPage> createState() => _PostDetailedPageState();
}

class _PostDetailedPageState extends State<PostDetailedPage> {
  late final _categoriesStore = HomeSetup.getIt<FetchCategoriesStore>();
  late final _store = PostsSetup.getIt<PostDetailStore>();
  late final ReactionDisposer _disposeReaction;

  CategoryModel? _category;

  /// Endereço cujo post já foi pedido. A navbar recarrega as categorias a
  /// cada página, e isso não deve buscar o post de novo.
  String? _requested;

  String get _address => '${widget.area.key}/${widget.categoryKey}/${widget.postId}';

  @override
  void initState() {
    super.initState();
    _disposeReaction = reaction((_) => _categoriesStore.state, (_) => _load());
    _load();
  }

  @override
  void didUpdateWidget(covariant PostDetailedPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.area != widget.area ||
        oldWidget.categoryKey != widget.categoryKey ||
        oldWidget.postId != widget.postId) {
      _requested = null;
      _load();
    }
  }

  @override
  void dispose() {
    _disposeReaction();
    super.dispose();
  }

  void _load() {
    final category = _categoriesStore.getCategoryByAreaAndKey(widget.area, widget.categoryKey);

    if (category != null) {
      if (_requested == _address) return;
      _requested = _address;
      _category = category;
      _categoriesStore.setSelectedCategory(category);
      _store.fetch(category, widget.postId);
      return;
    }

    _requested = null;
    // A 404 monta outra navbar, que recarrega as categorias: só o primeiro
    // carregamento mostra o esqueleto, senão a página alternaria sem parar.
    final resolved = _store.state is PostDetailNotFoundState;
    switch (_categoriesStore.state) {
      case FetchCategoriesSuccessState():
        if (!resolved) _store.setNotFound();
      case FetchCategoriesErrorState():
        if (!resolved) _store.setError();
      case FetchCategoriesInitialState() || FetchCategoriesLoadingState():
        if (_store.state is PostDetailInitialState) _store.setLoading();
    }
  }

  void _retry() {
    if (_categoriesStore.state is FetchCategoriesErrorState) {
      _store.setLoading();
      _categoriesStore.fetchCategories();
      return;
    }
    _requested = null;
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final state = _store.state;

        final Widget body;
        switch (state) {
          case PostDetailInitialState() || PostDetailLoadingState():
            body = const PostPageSkeleton();
          case PostDetailNotFoundState():
            return const PageNotFound();
          case PostDetailErrorState():
            body = _ErrorFrame(onRetry: _retry);
          case PostDetailSuccessState(:final post):
            final category = _category!;
            body = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PostTypeContent(post: post, area: widget.area, category: category),
                if (post.isArticle)
                  RelatedPostsSection(posts: _store.related.toList(), area: widget.area, category: category),
              ],
            );
        }

        // A chave por endereço volta ao topo ao abrir outro post pelo Leia também.
        return ReadingPageScaffold(key: ValueKey(_address), body: body, beforeFooter: const Support());
      },
    );
  }
}

class _ErrorFrame extends StatelessWidget {
  const _ErrorFrame({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final breakpoint = ScreenUtils.breakpointOf(context);

    return PostHeadFrame(
      child: Padding(
        padding: EdgeInsets.only(bottom: AppTheme.dimensions.components.readingPaddingBottom(breakpoint)),
        child: StateErrorBox(onRetry: onRetry),
      ),
    );
  }
}
