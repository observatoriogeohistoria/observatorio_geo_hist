import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/date/date.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/highlights/select_highlights.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Cartão de destaque da Home (spec 005).
///
/// A foto preenche o cartão (recortada, sem distorcer). Só na parte de baixo,
/// atrás do texto, um degradê escuro garante contraste mesmo sobre foto branca.
/// O cartão inteiro é um link para a página do post; o leitor de tela ouve
/// "Título. Tipo, Área. data" e ignora a foto.
class HighlightCard extends StatefulWidget {
  const HighlightCard({super.key, required this.post, this.isMain = false});

  /// Post completo (com `body`, `id` e área), já filtrado por [selectHighlights].
  final PostModel post;

  /// Cartão principal: título maior e data.
  final bool isMain;

  @override
  State<HighlightCard> createState() => _HighlightCardState();
}

class _HighlightCardState extends State<HighlightCard> {
  bool _hovered = false;

  PostModel get _post => widget.post;

  String get _typeAndArea => '${_post.type.portuguese} · ${highlightArea(_post)!.portuguese}';

  String? get _date => widget.isMain ? _post.createdAt?.shortDate : null;

  String get _semanticLabel {
    final parts = [
      _post.body!.title,
      '${_post.type.portuguese}, ${highlightArea(_post)!.portuguese}',
      if (_date != null) _date!,
    ];
    return '${parts.join('. ')}.';
  }

  void _open() => GoRouter.of(context).go(highlightPath(_post));

  @override
  Widget build(BuildContext context) {
    final compact = !widget.isMain && ScreenUtils.breakpointOf(context) == Breakpoint.mobile;

    return Semantics(
      link: true,
      label: _semanticLabel,
      linkUrl: Uri.parse(highlightPath(_post)),
      // Repete a ação do InkWell (excluído da semântica) para o leitor de tela ativar o cartão.
      onTap: _open,
      excludeSemantics: true,
      child: compact ? _buildCompact(context) : _buildOverlay(context),
    );
  }

  /// Secundário no celular: miniatura à esquerda e texto escuro sobre a página.
  Widget _buildCompact(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r10);

    return AppFocusRing(
      borderRadius: radius,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: _open,
          onHover: (value) => setState(() => _hovered = value),
          borderRadius: radius,
          splashFactory: NoSplash.splashFactory,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          mouseCursor: SystemMouseCursors.click,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: components.featuredCompactThumbWidth,
                child: AspectRatio(
                  aspectRatio: components.featuredCompactThumbAspectRatio,
                  child: ClipRRect(
                    borderRadius: radius,
                    child: ColoredBox(
                      color: colors.imagePlaceholder,
                      child: _HighlightImage(url: _post.body!.image.url, compact: true),
                    ),
                  ),
                ),
              ),
              SizedBox(width: components.featuredCompactGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _typeAndArea.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styles.label.copyWith(color: colors.accentStrong),
                    ),
                    SizedBox(height: components.featuredCompactTextGap),
                    Text(
                      _post.body!.title,
                      maxLines: components.featuredTitleMaxLines,
                      overflow: TextOverflow.ellipsis,
                      style: styles.featureTitleSmall.copyWith(
                        color: colors.ink,
                        decoration: _hovered ? TextDecoration.underline : TextDecoration.none,
                        decorationColor: colors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r16);

    return AppFocusRing(
      borderRadius: radius,
      fit: StackFit.expand,
      child: ClipRRect(
        borderRadius: radius,
        child: Material(
          color: AppTheme.colors.imagePlaceholder,
          child: InkWell(
            onTap: _open,
            onHover: (value) => setState(() => _hovered = value),
            splashFactory: NoSplash.splashFactory,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            mouseCursor: SystemMouseCursors.click,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _HighlightImage(url: _post.body!.image.url),
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Flexible(
                        child: Stack(
                          // Mantém a largura toda do cartão para o bloco de texto.
                          fit: StackFit.passthrough,
                          clipBehavior: Clip.none,
                          children: [
                            _textBlock(context),
                            // Desenhada acima do texto, sem tirar altura dele.
                            Positioned(
                              left: 0,
                              right: 0,
                              top: -AppTheme.dimensions.components.featuredScrimFade,
                              height: AppTheme.dimensions.components.featuredScrimFade,
                              child: const _ScrimFade(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textBlock(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final breakpoint = ScreenUtils.breakpointOf(context);
    final textScaler = MediaQuery.textScalerOf(context);

    final titleStyle = (widget.isMain ? styles.featureTitle : styles.featureTitleSmall).copyWith(
      color: colors.white,
      decoration: _hovered ? TextDecoration.underline : TextDecoration.none,
      decorationColor: colors.white,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colors.imageScrim.withValues(alpha: components.featuredScrimTextOpacity),
            colors.imageScrim.withValues(alpha: components.featuredScrimBottomOpacity),
          ],
        ),
      ),
      child: ClipRect(
        child: Padding(
          padding: EdgeInsets.all(components.featuredTextPadding(breakpoint)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _typeAndArea.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: styles.label.copyWith(color: colors.onImageAccent),
              ),
              SizedBox(height: components.featuredTextGap),
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: widget.isMain
                        ? textScaler.scale(titleStyle.fontSize!) * components.featuredTitleMaxWidthEm
                        : double.infinity,
                  ),
                  // Com pouco espaço (texto ampliado), corta em menos linhas, com reticências.
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final lineHeight = textScaler.scale(titleStyle.fontSize!) * titleStyle.height!;
                      final fitting = (constraints.maxHeight / lineHeight).floor();
                      final maxLines = fitting.clamp(1, components.featuredTitleMaxLines);

                      return Text(
                        _post.body!.title,
                        maxLines: maxLines,
                        overflow: TextOverflow.ellipsis,
                        style: titleStyle,
                      );
                    },
                  ),
                ),
              ),
              if (_date != null) ...[
                SizedBox(height: components.featuredTextGap),
                Text(
                  _date!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: styles.small.copyWith(color: colors.onImageMuted),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Faixa acima do texto em que o véu escuro esmaece até sumir. A parte de
/// cima da foto fica limpa.
class _ScrimFade extends StatelessWidget {
  const _ScrimFade();

  @override
  Widget build(BuildContext context) {
    final scrim = AppTheme.colors.imageScrim;
    final components = AppTheme.dimensions.components;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            scrim.withValues(alpha: 0),
            scrim.withValues(alpha: components.featuredScrimTextOpacity),
          ],
        ),
      ),
    );
  }
}

/// Foto do post em `cover`. Sem URL, carregando ou com falha: fica o fundo
/// escuro do cartão (sem salto de layout); sem URL ou com falha, também o
/// ícone de imagem no canto. Decorativa para o leitor de tela.
class _HighlightImage extends StatelessWidget {
  const _HighlightImage({required this.url, this.compact = false});

  final String? url;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final url = this.url;
    if (url == null || url.isEmpty) return _NoImage(compact: compact);

    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return ExcludeSemantics(
      child: Image.network(
        url,
        fit: BoxFit.cover,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: reduceMotion ? Duration.zero : AppTheme.dimensions.components.featuredImageFade,
            child: child,
          );
        },
        errorBuilder: (context, error, stackTrace) => _NoImage(compact: compact),
      ),
    );
  }
}

class _NoImage extends StatelessWidget {
  const _NoImage({this.compact = false});

  /// Na miniatura, o ícone fica no centro.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final breakpoint = ScreenUtils.breakpointOf(context);

    return ExcludeSemantics(
      child: ColoredBox(
        color: AppTheme.colors.imagePlaceholder,
        child: Align(
          alignment: compact ? Alignment.center : Alignment.topLeft,
          child: Padding(
            padding: compact
                ? EdgeInsets.zero
                : EdgeInsets.all(AppTheme.dimensions.components.featuredTextPadding(breakpoint)),
            child: Icon(
              Icons.image_outlined,
              size: AppTheme.dimensions.components.featuredPlaceholderIcon,
              color: AppTheme.colors.onImageMuted,
            ),
          ),
        ),
      ),
    );
  }
}
