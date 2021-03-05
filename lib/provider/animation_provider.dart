import 'dart:async';

import 'package:flutter/material.dart';

class AnimationProvider {
  static const Duration expandedDuration = Duration(milliseconds: 300);

  Timer? _timer;

  AnimationController? fadeButtonController;
  late Animation<double> fadeButtonAnimation;

  AnimationController? fadeSettingsController;
  late Animation<double> fadeSettingsAnimation;
  
  AnimationController?  monthAnimationController;
  Animation<double>? monthlyAnimation;

  AnimationController?  finalAnimationController;    
  Animation<double>? finalAnimation;

  void buttonFade(){
    cancelTimer();
    fadeButtonController?.value = 1.0;
    fadeSettingsController?.value = 1.0;

    _timer = Timer(const Duration(seconds: 3), (){
      fadeButtonController?.reverse(from: 1.0);
      fadeSettingsController?.reverse(from: 1.0);
    });
  }

  void cancelTimer(){
    _timer?.cancel();
  }

  void dispose() { 
    fadeButtonController?.dispose();
    fadeSettingsController?.dispose();
    monthAnimationController?.dispose();
    finalAnimationController?.dispose();
  }
}