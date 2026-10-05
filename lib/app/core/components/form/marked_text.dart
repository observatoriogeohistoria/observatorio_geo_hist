import 'package:flutter/material.dart';

/// Texto com trechos `**assim**` em negrito, para os textos de apoio virem prontos de fora.
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
