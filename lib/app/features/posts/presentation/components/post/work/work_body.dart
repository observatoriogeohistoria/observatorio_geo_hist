import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/chips/labels.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/fact_sheet.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_blocks.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_column.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_rich_text.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/article_body.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/post_breadcrumbs.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/post_share.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/work/work_extras.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/work/work_image.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/work/work_info.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class WorkBody extends StatelessWidget {
  const WorkBody({
    super.key,
    required this.post,
    required this.info,
    required this.area,
    required this.category,
  });

  final PostModel post;
  final WorkInfo info;
  final PostsAreas area;
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final stacked = info.image == null || ScreenUtils.breakpointOf(context) == Breakpoint.mobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PostHeadFrame(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PostBreadcrumbs(area: area, category: category, typeLabel: info.typeLabel),
              SizedBox(height: components.postTitleGap),
              _WorkBlock(info: info),
              // A linha de baixo da ficha já separa o compartilhar; duas seguidas
              // pareciam uma faixa vazia.
              _ShareRow(
                post: post,
                joined: stacked && info.action == null && info.listen == null && info.hasSheet,
              ),
            ],
          ),
        ),
        _WorkTexts(texts: info.texts),
      ],
    );
  }
}

class _WorkBlock extends StatelessWidget {
  const _WorkBlock({required this.info});

  final WorkInfo info;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);
    final gap = components.workBlockGap(breakpoint);
    final data = _WorkData(info: info);
    final image = info.image;

    if (image == null) return data;

    final title = info.title.trim();
    final picture = switch (image.kind) {
      WorkImageKind.cover => WorkCover(url: image.url, title: title),
      WorkImageKind.square => WorkCover(
          url: image.url,
          title: title,
          aspectRatio: components.workSquareAspect,
        ),
      WorkImageKind.poster => WorkPoster(url: image.url, title: title, link: image.link),
    };

    if (breakpoint == Breakpoint.mobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (image.kind == WorkImageKind.poster)
            picture
          else
            Align(alignment: Alignment.centerLeft, child: picture),
          SizedBox(height: gap),
          data,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: switch (image.kind) {
        WorkImageKind.cover || WorkImageKind.square => [
            picture,
            SizedBox(width: gap),
            Expanded(child: data)
          ],
        WorkImageKind.poster => [
            Expanded(flex: components.workPosterFlex, child: picture),
            SizedBox(width: gap),
            Expanded(flex: components.workDataFlex, child: data),
          ],
      },
    );
  }
}

class _WorkData extends StatelessWidget {
  const _WorkData({required this.info});

  final WorkInfo info;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final badge = info.badge.trim();
    final teaser = info.teaser.trim();
    final action = info.action;
    final listen = info.listen;

    // Ao lado da capa, o Flutter ordena a leitura pela posição na tela e anunciava o botão
    // antes da chamada da revista; o contêiner mantém a ordem da coluna.
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (badge.isNotEmpty) ...[
            Align(alignment: Alignment.centerLeft, child: TypeBadge(badge, wrap: true)),
            SizedBox(height: components.workTitleGap),
          ],
          Semantics(
            header: true,
            headingLevel: 1,
            child: Text(info.title.trim(), style: styles.detailTitle.copyWith(color: colors.ink)),
          ),
          if (teaser.isNotEmpty) ...[
            SizedBox(height: components.postSubtitleGap),
            Text(teaser, style: styles.postSubtitle.copyWith(color: colors.inkSecondary)),
          ],
          FactSheet(facts: info.facts, tagsLabel: info.tagsLabel, tags: info.tags),
          if (listen != null) ...[
            SizedBox(height: components.workActionTop),
            WorkListenButton(listen: listen, title: info.title.trim()),
          ],
          if (action != null) ...[
            SizedBox(height: components.workActionTop),
            _ActionButton(action: action),
          ],
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.action});

  final WorkAction action;

  @override
  Widget build(BuildContext context) {
    void open() => openUrl(action.url);
    final mobile = ScreenUtils.breakpointOf(context) == Breakpoint.mobile;

    final button = Semantics(
      button: true,
      label: '${action.label} em outra aba',
      onTap: open,
      excludeSemantics: true,
      child: PrimaryButton.medium(
        text: action.label,
        trailingIcon: Icons.open_in_new,
        expand: mobile,
        onPressed: open,
      ),
    );

    if (mobile) return button;
    return Align(alignment: Alignment.centerLeft, child: button);
  }
}

class _ShareRow extends StatelessWidget {
  const _ShareRow({required this.post, required this.joined});

  final PostModel post;
  final bool joined;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final line = BorderSide(color: AppTheme.colors.line);

    return Container(
      margin: EdgeInsets.only(top: joined ? 0 : components.workShareMarginTop),
      padding: EdgeInsets.symmetric(vertical: components.workSharePaddingVertical),
      decoration: BoxDecoration(
        border: Border(top: joined ? BorderSide.none : line, bottom: line),
      ),
      alignment: Alignment.centerLeft,
      child: PostShare(post: post),
    );
  }
}

class _WorkTexts extends StatelessWidget {
  const _WorkTexts({required this.texts});

  final List<WorkText> texts;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final blocks = [
      for (final text in texts)
        if (_contentOf(text) case final content?) (text.title, content),
    ];

    if (blocks.isEmpty) {
      return SizedBox(
        height: components.readingPaddingBottom(ScreenUtils.breakpointOf(context)),
      );
    }

    // O subtítulo traz a própria margem de topo; descontá-la deixa o vão igual ao do artigo.
    return ReadingColumn(
      paddingTop: components.postBodyPaddingTop -
          (components.readingSubtitleMarginTop - components.readingParagraphGap),
      children: [
        for (final (title, content) in blocks) ...[ReadingSubtitle(title), content],
      ],
    );
  }

  static Widget? _contentOf(WorkText text) {
    final content = text.content;
    final rich = text.isRich && ReadingRichText.isDelta(content);
    final empty = rich ? ReadingRichText.isEmpty(content) : ReadingPlainText.isEmpty(content);

    if (empty) return null;
    return rich ? ReadingRichText(content) : ReadingPlainText(content);
  }
}
