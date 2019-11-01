import 'package:flutter/material.dart';

class FifteenFontText extends Text {
  const FifteenFontText(
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
