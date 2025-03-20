import 'dart:ui';

/// An extension on the [num] class that provides methods for scaling based on the screen size
extension NumExtension on num {
  /// Base width (reference device)
  static const baseWidth = 1440;

  /// Base height (reference device)
  static const baseHeight = 788;

  /// Retrieves the screen's width and height scaling factors
  _ScalingFactors _getScalingFactors() {
    if (this == double.infinity) return _ScalingFactors(1, 1, 1);

    final base = PlatformDispatcher.instance.views.first;
    final screenSize = base.physicalSize / base.devicePixelRatio;
    final widthFactor = screenSize.width / baseWidth;
    final heightFactor = screenSize.height / baseHeight;

    // Check if the screen is in landscape mode
    final isLandscape = screenSize.width > screenSize.height;

    // Adjust the scaling factors based on the screen orientation
    final scaleFactor = isLandscape
        ? (widthFactor * 0.7) + (heightFactor * 0.3) // In landscape, more weight on width
        : (widthFactor * 0.4) + (heightFactor * 0.6); // In portrait, more weight on height

    return _ScalingFactors(widthFactor, heightFactor, scaleFactor);
  }

  /// Calculates the font size based on the screen size, clamped between min and max values
  double get fontSize {
    final scaleFactor = _getScalingFactors().scaleFactor;

    const min = 12.0;
    const max = 40.0;

    return (this * scaleFactor).clamp(min, max);
  }

  /// Calculates a horizontal spacing based on the screen size (for padding/margin)
  double get horizontalSpacing {
    final scaleFactor = _getScalingFactors().widthFactor;

    const minScale = 0.85; // Maintains good visibility on smaller screens
    const maxScale = 1.2; // Avoids excessive growth

    return (this * scaleFactor).clamp(this * minScale, this * maxScale);
  }

  /// Calculates a vertical spacing based on the screen size (for padding/margin)
  double get verticalSpacing {
    final scaleFactor = _getScalingFactors().heightFactor;

    const minScale = 0.9; // Maintains good visibility on smaller screens
    const maxScale = 1.3; // Avoids excessive growth

    return (this * scaleFactor).clamp(this * minScale, this * maxScale);
  }

  /// Calculates the scale based on the screen size
  double get scale {
    final scaleFactor = _getScalingFactors().scaleFactor;

    const minScale = 0.8; // Avoids very small icons
    const maxScale = 1.5; // Avoids very large icons

    return (this * scaleFactor).clamp(this * minScale, this * maxScale);
  }
}

/// Private class to hold scaling factors
class _ScalingFactors {
  _ScalingFactors(this.widthFactor, this.heightFactor, this.scaleFactor);

  final double widthFactor;
  final double heightFactor;
  final double scaleFactor;
}
