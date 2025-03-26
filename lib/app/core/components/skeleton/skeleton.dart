import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF5F5F4), Color(0xFFE7E5E4), Color(0xFFF5F5F4)],
        ),
      ),
    );
  }
}
