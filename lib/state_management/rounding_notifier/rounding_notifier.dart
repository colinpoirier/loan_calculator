import 'dart:math' as math;

import 'package:flutter/animation.dart';
import 'package:loan_calc_dev/calculation/utils.dart';
import 'package:loan_calc_dev/dialogs/dialogs.dart';
import 'package:loan_calc_dev/models/data_classes.dart';
import 'package:loan_calc_dev/convience_classes/saved_index.dart';
import 'package:loan_calc_dev/state_management/calculation_notifier/calculation_notifier.dart';
import 'package:loan_calc_dev/state_management/input_notifier/input_notifier.dart';
import 'package:loan_calc_dev/state_management/input_notifier/input_notifier_state.dart';
import 'package:loan_calc_dev/state_management/rounding_notifier/rounding_notifier_state.dart';
import 'package:loan_calc_dev/storage/input_tracker/input_tracker_notifier.dart';

class RoundingNotifier extends CalcNotifier<RoundingState> {
  RoundingNotifier({
    required InputNotifier inputNotifier,
    required this.inputTrackerNotifier,
    required this.monthlyPaymentController,
    required this.savedIndex,
  }) : super(RoundingState()) {
    inputNotifier.addListener(() {
      if (inputNotifier.state != _inputState && !state.isEditing) {
        setState(state.updateEditing(isEditing: true));
      } else if (inputNotifier.state == _inputState && state.isEditing) {
        setState(state.updateEditing(isEditing: false));
      }
    });
  }

  final AnimationController monthlyPaymentController;
  final InputTrackerNotifier inputTrackerNotifier;
  final SavedIndex savedIndex;

  InputState? _inputState;
  InputState get inputState => _inputState!;
  // bool isTooSmall(double roundedDown) => (_inputState!.amount * _inputState!.percent) >= roundedDown;

  void calculate(InputState inputState) async {
    ShowDialogs.unFocus();
    if (inputState == _inputState) return;
    _inputState = inputState;
  //   final amount = inputState.amount;
  //   final percent = inputState.percent;
  //   final length = inputState.length;
  //   final payment = (percent * amount) / (1 - math.pow(1 + percent, -length));
  //   if (state.roundUp) {
  //     double roundedPayment = roundUp(payment, inputState.precision);
  //     if (roundedPayment == state.precisePayment) {
  //       roundedPayment += 1 / math.pow(10, inputState.precision);
  //     }
  //     setState(
  //         state.copyWith(precisePayment: payment, roundedPayment: roundedPayment, precision: inputState.precision));
  //   } else if (state.roundDown) {
  //     final roundedPayment = roundDown(payment, inputState.precision);
  //     if (isTooSmall(roundedPayment)) {
  //       setState(state.copyWith(precisePayment: payment, roundDown: false, precision: inputState.precision));
  //       ShowDialogs.ooops(state.precisePayment!, inputState.amount * inputState.percent, inputState.precision);
  //       return;
  //     }
  //     setState(
  //         state.copyWith(precisePayment: payment, roundedPayment: roundedPayment, precision: inputState.precision));
  //   } else {
  //     setState(state.copyWith(precisePayment: payment, precision: inputState.precision));
  //   }
  //   monthlyPaymentController.forward();
  //   savedIndex.reset();
  //   await inputTrackerNotifier.addToIpt(InputTracker(
  //     month: inputState.lengthString,
  //     amount: inputState.amountString,
  //     percent: inputState.percentString,
  //   ));
  // }

  // void roundUpChange(bool? val) {
  //   double? rounded;
  //   if (val!) {
  //     rounded = roundUp(state.precisePayment!, state.precision!);
  //     if (rounded == state.precisePayment) {
  //       rounded += 1 / math.pow(10, state.precision!);
  //     }
  //   }
  //   setState(state.copyWith(roundUp: val, roundedPayment: rounded, roundDown: false));
  //   savedIndex.reset();
  // }

  // void roundDownChange(bool? val) {
  //   double? rounded;
  //   if (val!) {
  //     rounded = roundDown(state.precisePayment!, state.precision!);
  //     if (isTooSmall(rounded)) {
  //       ShowDialogs.ooops(state.precisePayment!, _inputState!.amount * _inputState!.percent, state.precision!);
  //       return;
  //     }
  //   }
  //   setState(state.copyWith(roundDown: val, roundedPayment: rounded, roundUp: false));
  //   savedIndex.reset();
  }
}
