import 'package:flutter/material.dart';

class Animations {
  Animations({required TickerProvider vsync})
      : monthAnimationController = AnimationController(
          vsync: vsync,
          duration: Animations.expandedDuration,
        ),
        finalAnimationController = AnimationController(
          vsync: vsync,
          duration: Animations.expandedDuration,
        ) {
    monthlyAnimation = CurvedAnimation(
      parent: monthAnimationController,
      curve: Curves.fastOutSlowIn,
    );
    finalAnimation = CurvedAnimation(
      parent: finalAnimationController,
      curve: Curves.fastOutSlowIn,
    );
  }

  static const Duration expandedDuration = Duration(milliseconds: 300);

  final AnimationController monthAnimationController;
  late Animation<double> monthlyAnimation;

  final AnimationController finalAnimationController;
  late Animation<double> finalAnimation;

  void dispose() {
    monthAnimationController.dispose();
    finalAnimationController.dispose();
  }
}
