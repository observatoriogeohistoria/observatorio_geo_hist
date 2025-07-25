import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppMouseRegion extends StatelessWidget {
  const AppMouseRegion({
    required this.child,
    this.showClickCursor = true,
    this.onEnter,
    this.onExit,
    super.key,
  });

  final Widget child;
  final bool showClickCursor;

  final void Function(PointerEnterEvent)? onEnter;
  final void Function(PointerExitEvent)? onExit;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: showClickCursor ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: onEnter,
      onExit: onExit,
      child: child,
    );
  }
}
