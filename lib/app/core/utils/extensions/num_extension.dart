import 'dart:ui';

extension NumExtension on num {
  static const baseWidth = 1440;

  static const baseHeight = 788;

  _ScalingFactors _getScalingFactors() {
    if (this == double.infinity) return _ScalingFactors(1, 1, 1);

    final base = PlatformDispatcher.instance.views.first;
    final screenSize = base.physicalSize / base.devicePixelRatio;
    final widthFactor = screenSize.width / baseWidth;
    final heightFactor = screenSize.height / baseHeight;

    final isLandscape = screenSize.width > screenSize.height;

    final scaleFactor = isLandscape
        ? (widthFactor * 0.7) + (heightFactor * 0.3)
        : (widthFactor * 0.4) + (heightFactor * 0.6);

    return _ScalingFactors(widthFactor, heightFactor, scaleFactor);
  }

  double fontSize({double min = 18.0, double max = 40.0}) {
    final scaleFactor = _getScalingFactors().scaleFactor;

    return (this * scaleFactor).clamp(min, max);
  }

  double get horizontalSpacing {
    final scaleFactor = _getScalingFactors().widthFactor;

    const minScale = 0.85;
    const maxScale = 2.0;

    return (this * scaleFactor).clamp(this * minScale, this * maxScale);
  }

  double get verticalSpacing {
    final scaleFactor = _getScalingFactors().heightFactor;

    const minScale = 0.9;
    const maxScale = 2.0;

    return (this * scaleFactor).clamp(this * minScale, this * maxScale);
  }

  double get scale {
    final scaleFactor = _getScalingFactors().scaleFactor;

    const minScale = 0.8;
    const maxScale = 1.5;

    return (this * scaleFactor).clamp(this * minScale, this * maxScale);
  }
}

class _ScalingFactors {
  _ScalingFactors(this.widthFactor, this.heightFactor, this.scaleFactor);

  final double widthFactor;
  final double heightFactor;
  final double scaleFactor;
}
