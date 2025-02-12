import 'package:flutter/material.dart';

class AppMouseRegion extends StatelessWidget {
  const AppMouseRegion({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: child,
    );
  }
}
