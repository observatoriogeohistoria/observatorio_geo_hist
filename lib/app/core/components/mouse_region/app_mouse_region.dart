import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppMouseRegion extends StatelessWidget {
  const AppMouseRegion({
    required this.child,
    this.onEnter,
    this.onExit,
    super.key,
  });

  final Widget child;

  final void Function(PointerEnterEvent)? onEnter;
  final void Function(PointerExitEvent)? onExit;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: onEnter,
      onExit: onExit,
      child: child,
    );
  }
}
