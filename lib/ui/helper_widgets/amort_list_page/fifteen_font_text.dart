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

class SixteenFontRichText extends RichText {
  SixteenFontRichText({
    this.top,
    this.bottom,
    this.style,
  }) : super(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          text: TextSpan(
            style: style.copyWith(fontSize: 16),
            children: [
              TextSpan(
                text: top,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: bottom,
              )
            ],
          ),
        );

  final String top;
  final String bottom;
  final TextStyle style;
}
