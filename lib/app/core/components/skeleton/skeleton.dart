import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class Skeleton extends StatefulWidget {
  const Skeleton({
    required this.width,
    required this.height,
    super.key,
  });

  final double? width;
  final double? height;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppTheme.dimensions.components.skeletonShimmer,
  );
  late final CurvedAnimation _progress = CurvedAnimation(parent: _controller, curve: Curves.ease);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _progress.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final animate = !MediaQuery.disableAnimationsOf(context);

    return RepaintBoundary(
      child: CustomPaint(
        painter: animate
            ? _ShimmerPainter(
                progress: _progress,
                base: colors.skeletonBase,
                highlight: colors.skeletonHighlight,
              )
            : null,
        child: Container(
          width: widget.width,
          height: widget.height,
          color: animate ? null : colors.skeletonBase,
        ),
      ),
    );
  }
}

class _ShimmerPainter extends CustomPainter {
  _ShimmerPainter({required this.progress, required this.base, required this.highlight})
      : super(repaint: progress);

  final Animation<double> progress;
  final Color base;
  final Color highlight;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      colors: [base, highlight, base],
      stops: const [0.25, 0.37, 0.63],
      transform: _SlidingGradient(progress.value),
    );
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }

  @override
  bool shouldRepaint(_ShimmerPainter oldDelegate) =>
      oldDelegate.base != base || oldDelegate.highlight != highlight;
}

// O degradê tem quatro larguras do bloco e desliza até encostar nele, então a faixa
// clara atravessa o bloco uma vez por ciclo e as pontas ficam na cor base.
class _SlidingGradient extends GradientTransform {
  const _SlidingGradient(this.progress);

  final double progress;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    final offset = -3 * bounds.width * (1 - progress);
    return Matrix4.translationValues(bounds.left + offset, 0, 0)
      ..multiply(Matrix4.diagonal3Values(4, 1, 1))
      ..multiply(Matrix4.translationValues(-bounds.left, 0, 0));
  }
}
