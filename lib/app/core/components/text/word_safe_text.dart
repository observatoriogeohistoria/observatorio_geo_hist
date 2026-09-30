import 'dart:math';

import 'package:flutter/material.dart';

/// Texto que nunca quebra uma palavra ao meio: se a mais longa não cabe na
/// largura (tela estreita com texto ampliado), a fonte diminui só o
/// necessário para ela caber. Nos demais casos, é um [Text] comum.
class WordSafeText extends StatelessWidget {
  const WordSafeText(this.text, {super.key, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final widest = _widestWord(context);
        final fits = !constraints.hasBoundedWidth || widest <= constraints.maxWidth;
        if (fits) return Text(text, style: style);

        final factor = constraints.maxWidth / widest;
        return Text(
          text,
          style: style.copyWith(
            fontSize: (style.fontSize! * factor).floorToDouble(),
            letterSpacing: style.letterSpacing == null ? null : style.letterSpacing! * factor,
          ),
        );
      },
    );
  }

  double _widestWord(BuildContext context) {
    final painter = TextPainter(
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    );
    var widest = 0.0;
    for (final word in text.split(RegExp(r'\s+'))) {
      painter
        ..text = TextSpan(text: word, style: style)
        ..layout();
      widest = max(widest, painter.width);
    }
    painter.dispose();
    return widest;
  }
}
