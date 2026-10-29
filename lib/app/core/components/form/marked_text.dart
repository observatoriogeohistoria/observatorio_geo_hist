import 'package:flutter/material.dart';

/// Text with `**like this**` parts in bold, so supporting texts come ready from outside.
class MarkedText extends StatelessWidget {
  const MarkedText(this.text, {super.key, required this.style, this.textAlign});

  final String text;
  final TextStyle style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final parts = text.split('**');
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          for (final (index, part) in parts.indexed)
            TextSpan(
              text: part,
              style: index.isOdd ? const TextStyle(fontWeight: FontWeight.w700) : null,
            ),
        ],
      ),
      textAlign: textAlign,
    );
  }
}
