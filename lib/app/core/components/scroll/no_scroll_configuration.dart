import 'package:flutter/material.dart';

class NoScrollConfiguration extends StatelessWidget {
  const NoScrollConfiguration({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: child,
    );
  }
}
