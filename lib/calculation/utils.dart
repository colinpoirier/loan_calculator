import 'dart:math';

import 'package:flutter/material.dart';

double roundUp(double val, int precision) {
  final scale = pow(10, precision);
  return (val * scale).ceilToDouble() / scale;
}

double roundDown(double val, int precision) {
  final scale = pow(10, precision);
  return (val * scale).floorToDouble() / scale;
}

double roundToPrecision(double val, int precision) {
  final scale = pow(10, precision);
  return (val * scale).roundToDouble() / scale;
}

double getFontSize(
  double startFont,
  double? height,
  double maxWidth,
  String monthlyPayment,
  TextDirection textDirection,
) {
  double fontSize = startFont;
  for (int i = 0; i < 25; i++) {
    final ts = TextSpan(
      text: monthlyPayment,
      style: TextStyle(
        fontSize: fontSize,
        height: height,
      ),
    );
    final tp = TextPainter(
      text: ts,
      textDirection: textDirection,
      maxLines: 1,
    )..layout();
    if (tp.width >= maxWidth.floor()) {
      fontSize -= 1;
    } else {
      break;
    }
  }
  return fontSize;
}
