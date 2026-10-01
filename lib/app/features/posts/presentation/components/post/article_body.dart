import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_column.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_rich_text.dart';
import 'package:observatorio_geo_hist/app/core/models/article_model.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/article_header.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/article_note.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Layout-base do post para o tipo artigo (spec 012): cabeçalho de até 820 px
/// e, abaixo, texto e nota na coluna de leitura.
class ArticleBody extends StatelessWidget {
  const ArticleBody({
    super.key,
    required this.post,
    required this.article,
    required this.area,
    required this.category,
  });

  final PostModel post;
  final ArticleModel article;
  final PostsAreas area;
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final hasNote = !ReadingRichText.isEmpty(article.observation);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PostHeadFrame(
          child: ArticleHeader(post: post, article: article, area: area, category: category),
        ),
        ReadingColumn(
          paddingTop: components.postBodyPaddingTop,
          children: [
            ReadingRichText(article.content),
            if (hasNote) ...[
              SizedBox(height: components.postNoteMarginTop - components.readingParagraphGap),
              ArticleNote(observation: article.observation),
            ],
          ],
        ),
      ],
    );
  }
}

/// Faixa do cabeçalho do post: até 820 px com as margens, centralizada, com o
/// respiro do topo das páginas de texto.
class PostHeadFrame extends StatelessWidget {
  const PostHeadFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final margin = ScreenUtils.contentMargin(ScreenUtils.breakpointOf(context));

    return PageContent(
      child: Padding(
        padding: EdgeInsets.only(top: components.pageHeadPaddingTop),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: components.postHeadMaxWidth - 2 * margin),
            child: child,
          ),
        ),
      ),
    );
  }
}
