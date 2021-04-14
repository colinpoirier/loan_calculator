import 'package:flutter/animation.dart';
import 'package:loan_calc_dev/calculation/utils.dart';
import 'package:loan_calc_dev/models/data_classes.dart';
import 'package:loan_calc_dev/state_management/calculation_notifier/calculation_notifier.dart';
import 'package:loan_calc_dev/state_management/final_notifier/final_notifier_state.dart';
import 'package:loan_calc_dev/state_management/input_notifier/input_notifier_state.dart';
import 'package:loan_calc_dev/state_management/rounding_notifier/rounding_notifier.dart';
import 'package:loan_calc_dev/state_management/rounding_notifier/rounding_notifier_state.dart';

class FinalNotifier extends CalcNotifier<FinalState> {
  FinalNotifier({
    required RoundingNotifier roundingNotifier,
    required AnimationController finalPaymentController,
  }) : super(FinalState()) {
    roundingNotifier.addListener(() {
      final rnState = roundingNotifier.state;
      if (!rnState.isEditing) {
        if (rnState.roundDown || rnState.roundUp) {
          amortizer(roundingNotifier.inputState, rnState);
          finalPaymentController.forward();
        } else if (state.finalPayment != null) {
          setState(FinalState(precision: state.precision, isEditing: state.isEditing));
          finalPaymentController.reverse();
        }
      }
      if (state.finalPayment != null) {
        if (rnState.isEditing && !state.isEditing) {
          setState(state.copyWith(isEditing: true));
        } else if (!rnState.isEditing && state.isEditing) {
          setState(state.copyWith(isEditing: false));
        }
      }
      _roundedPayment = rnState.roundedPayment;
    });
  }

  double? _roundedPayment;

  void amortizer(InputState inputState, RoundingState roundingState) {
    if (_roundedPayment == roundingState.roundedPayment) return;
    final mbdList = <MonthlyBreakDown>[];
  //   final amount = inputState.amount;
  //   final months = inputState.length;
  //   final percent = inputState.percent;
  //   final roundedPayment = roundingState.roundedPayment!;
  //   final precision = inputState.precision;
  //   double finalPayment = 0.0;
  //   double amountTemp = amount;
  //   double intTracker = 0.0;
  //   double princTracker = 0.0;
  //   double interest = 0.0;
  //   double temp = 0.0;
  //   for (int n = 1; n <= months; n++) {
  //     if (roundedPayment > (amountTemp * percent)) {
  //       if (n == months || (amount - princTracker) < roundedPayment) {
  //         interest = amountTemp * percent;
  //         finalPayment = amount - princTracker + interest;
  //         intTracker += interest;
  //         temp = finalPayment - interest;
  //         princTracker += temp;
  //         mbdList.add(MonthlyBreakDown(
  //           paidInt: roundToPrecision(interest, precision),
  //           month: n,
  //           paidPrinc: roundToPrecision(temp, precision),
  //           payment: roundToPrecision(finalPayment, precision),
  //           totPrinc: roundToPrecision(princTracker, precision),
  //           totInt: roundToPrecision(intTracker, precision),
  //         ));
  //         break;
  //       } else {
  //         interest = amountTemp * percent;
  //         intTracker += interest;
  //         temp = roundedPayment - interest;
  //         princTracker += temp;
  //         amountTemp = amountTemp - temp;
  //         mbdList.add(MonthlyBreakDown(
  //           paidInt: roundToPrecision(interest, precision),
  //           month: n,
  //           paidPrinc: roundToPrecision(temp, precision),
  //           payment: roundToPrecision(roundedPayment, precision),
  //           totPrinc: roundToPrecision(princTracker, precision),
  //           totInt: roundToPrecision(intTracker, precision),
  //         ));
  //       }
  //     } else {
  //       finalPayment = 0.0;
  //       break;
  //     }
  //   }
  //   setState(state.copyWith(mbdList: mbdList, finalPayment: finalPayment, precision: inputState.precision));
  }
}
