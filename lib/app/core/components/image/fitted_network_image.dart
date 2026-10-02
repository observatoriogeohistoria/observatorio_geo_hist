import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

/// As imagens chegam dos autores em tamanho original. Decodificá-las no tamanho em que
/// aparecem evita travadas no scroll quando entram na tela e poupa memória.
class FittedNetworkImage extends StatelessWidget {
  const FittedNetworkImage(
    this.url, {
    super.key,
    required this.fit,
    this.width,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.frameBuilder,
    this.errorBuilder,
  }) : assert(fit == BoxFit.cover || fit == BoxFit.contain);

  final String url;
  final BoxFit fit;
  final double? width;
  final String? semanticLabel;
  final bool excludeFromSemantics;
  final ImageFrameBuilder? frameBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        ImageProvider image = NetworkImage(url);
        if (constraints.hasBoundedWidth && constraints.hasBoundedHeight) {
          final ratio = MediaQuery.devicePixelRatioOf(context);
          image = _FittedImage(
            image,
            width: _quantize(constraints.maxWidth * ratio),
            height: _quantize(constraints.maxHeight * ratio),
            cover: fit == BoxFit.cover,
          );
        }

        return Image(
          image: image,
          fit: fit,
          width: width,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          frameBuilder: frameBuilder,
          errorBuilder: errorBuilder,
        );
      },
    );
  }

  // Arredonda para cima em degraus: redimensionar a janela não decodifica a imagem a cada pixel.
  static int _quantize(double pixels) => (pixels / 64).ceil() * 64;
}

@immutable
class _FittedImageKey {
  const _FittedImageKey(this.providerKey, this.width, this.height, this.cover);

  final Object providerKey;
  final int width;
  final int height;
  final bool cover;

  @override
  bool operator ==(Object other) =>
      other is _FittedImageKey &&
      other.providerKey == providerKey &&
      other.width == width &&
      other.height == height &&
      other.cover == cover;

  @override
  int get hashCode => Object.hash(providerKey, width, height, cover);
}

// O ResizeImage do Flutter não sabe preencher como o cover: com a largura fixa, uma imagem
// mais larga que a caixa fica borrada. Aqui a escala sai do tamanho real da imagem.
class _FittedImage extends ImageProvider<_FittedImageKey> {
  const _FittedImage(this.image, {required this.width, required this.height, required this.cover});

  final ImageProvider image;
  final int width;
  final int height;
  final bool cover;

  @override
  Future<_FittedImageKey> obtainKey(ImageConfiguration configuration) {
    return image.obtainKey(configuration).then((key) => _FittedImageKey(key, width, height, cover));
  }

  @override
  ImageStreamCompleter loadImage(_FittedImageKey key, ImageDecoderCallback decode) {
    Future<ui.Codec> decodeFitted(ui.ImmutableBuffer buffer,
        {ui.TargetImageSizeCallback? getTargetSize}) {
      return decode(buffer, getTargetSize: (intrinsicWidth, intrinsicHeight) {
        final scaleX = width / intrinsicWidth;
        final scaleY = height / intrinsicHeight;
        final scale = cover ? math.max(scaleX, scaleY) : math.min(scaleX, scaleY);
        if (scale >= 1) return const ui.TargetImageSize();
        return ui.TargetImageSize(
          width: math.max(1, (intrinsicWidth * scale).ceil()),
          height: math.max(1, (intrinsicHeight * scale).ceil()),
        );
      });
    }

    return image.loadImage(key.providerKey, decodeFitted);
  }
}
