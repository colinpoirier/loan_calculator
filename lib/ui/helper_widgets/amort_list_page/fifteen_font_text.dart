import 'package:flutter/material.dart';

class SixteenFontText extends Text {
  const SixteenFontText(
    String data,
  ) : super(
          data,
          textScaleFactor: 1.0,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
          ),
        );
}
