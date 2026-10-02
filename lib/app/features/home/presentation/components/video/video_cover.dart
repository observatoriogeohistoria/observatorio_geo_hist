import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Capa do vídeo de apresentação da Home (spec 006).
///
/// Fundo: a imagem `assets/images/video-capa.webp`, recortada para preencher o
/// quadro, quando ela existe no projeto; senão (ou se falhar), uma capa
/// desenhada pelo site (degradê escuro com anéis). Na base, a legenda
/// "Conheça o Observatório" sobre um véu escuro, com [action] (o botão
/// "Assistir") ao lado, para não cobrir o título que a capa já traz. [child]
/// (a caixa de erro) fica centralizado no quadro.
///
/// Recebe do pai uma altura mínima e cresce se o texto ampliado pedir.
class VideoCover extends StatelessWidget {
  const VideoCover({super.key, this.child, this.action});

  static const caption = 'Conheça o Observatório';

  final Widget? child;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final breakpoint = ScreenUtils.breakpointOf(context);
    final horizontal = AppTheme.dimensions.components.videoCaptionPaddingHorizontal(breakpoint);

    return Stack(
      fit: StackFit.passthrough,
      children: [
        const Positioned.fill(child: _CoverBackground()),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cópia invisível da legenda: reserva no topo a mesma altura da
            // base, para o botão ficar no centro do quadro sem encostar nela.
            ExcludeSemantics(child: Opacity(opacity: 0, child: _Caption(action: action))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontal),
              child: Center(child: child),
            ),
            _Caption(action: action),
          ],
        ),
      ],
    );
  }
}

/// Legenda com véu escuro atrás do texto e uma faixa acima em que o véu
/// esmaece. Branco sobre o véu fica acima de 4,5:1 mesmo com capa branca.
/// No celular, com o botão, mostra só ele.
class _Caption extends StatelessWidget {
  const _Caption({this.action});

  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);
    final solid = colors.imageScrim.withValues(alpha: components.videoCaptionScrimOpacity);

    // No celular, a legenda e o véu cobririam o título que a capa já traz: fica
    // só o botão, e a legenda segue como título da seção para o leitor de tela.
    if (breakpoint == Breakpoint.mobile && action != null) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          components.videoCaptionPaddingHorizontal(breakpoint),
          0,
          components.videoCaptionPaddingHorizontal(breakpoint),
          components.videoCaptionPaddingBottom(breakpoint),
        ),
        child: Row(
          children: [
            Expanded(
              child: Semantics(header: true, label: VideoCover.caption, child: const SizedBox.shrink()),
            ),
            action!,
          ],
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: [
        ColoredBox(
          color: solid,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              components.videoCaptionPaddingHorizontal(breakpoint),
              0,
              components.videoCaptionPaddingHorizontal(breakpoint),
              components.videoCaptionPaddingBottom(breakpoint),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      VideoCover.caption,
                      maxLines: components.videoCaptionMaxLines,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.typography.of(context).videoCaption.copyWith(color: colors.white),
                    ),
                  ),
                ),
                if (action != null) ...[SizedBox(width: components.videoCaptionActionGap), action!],
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: -components.videoCaptionScrimFade,
          height: components.videoCaptionScrimFade,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [colors.imageScrim.withValues(alpha: 0), solid],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Imagem escolhida, quando existe; senão, a capa desenhada. Decorativa.
class _CoverBackground extends StatelessWidget {
  const _CoverBackground();

  /// Consulta o manifesto de assets uma vez só. Evita pedir um arquivo que não
  /// existe (e o 404 no console).
  static final Future<bool> _hasCoverImage = AssetManifest.loadFromAssetBundle(rootBundle)
      .then((manifest) => manifest.listAssets().contains(AppAssets.videoCover))
      .catchError((Object _) => false);

  static const _generated = RepaintBoundary(
    child: CustomPaint(painter: VideoCoverPainter(), size: Size.infinite),
  );

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: FutureBuilder<bool>(
        future: _hasCoverImage,
        builder: (context, snapshot) {
          if (snapshot.data != true) return _generated;

          return Image.asset(
            AppAssets.videoCover,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _generated,
          );
        },
      ),
    );
  }
}

/// Capa desenhada (`.video` do protótipo): degradê de 150° de [AppColors.ink]
/// a [AppColors.videoCoverEnd], com anéis brancos bem suaves.
class VideoCoverPainter extends CustomPainter {
  const VideoCoverPainter();

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final stroke = AppTheme.dimensions.stroke.small;
    final rect = Offset.zero & size;

    // Linha do degradê como no CSS: o ângulo vale em pixels, e o comprimento
    // faz os cantos opostos ficarem nas cores das pontas.
    final angle = components.videoCoverAngleDegrees * math.pi / 180;
    final direction = Offset(math.sin(angle), -math.cos(angle));
    final length = (size.width * math.sin(angle)).abs() + (size.height * math.cos(angle)).abs();
    final center = rect.center;
    final gradient = Paint()
      ..shader = ui.Gradient.linear(
        center - direction * (length / 2),
        center + direction * (length / 2),
        [colors.ink, colors.videoCoverMid, colors.videoCoverEnd],
        [0, components.videoCoverMidStop, 1],
      );
    canvas.drawRect(rect, gradient);

    final ringCenter = Offset(
      size.width * components.videoRingCenter.dx,
      size.height * components.videoRingCenter.dy,
    );
    final corners = [Offset.zero, Offset(size.width, 0), Offset(0, size.height), Offset(size.width, size.height)];
    final farthest = corners.map((corner) => (corner - ringCenter).distance).reduce(math.max);
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = colors.white.withValues(alpha: components.videoRingOpacity);
    final step = components.videoRingStep;
    for (var radius = step - stroke / 2; radius <= farthest; radius += step) {
      canvas.drawCircle(ringCenter, radius, ring);
    }
  }

  @override
  bool shouldRepaint(VideoCoverPainter oldDelegate) => false;
}
