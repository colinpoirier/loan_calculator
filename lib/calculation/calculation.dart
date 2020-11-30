import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loan_calc_dev/calculation/utils.dart';
import 'package:loan_calc_dev/dialogs/dialogs.dart';
import 'package:loan_calc_dev/models/data_classes.dart';
import 'package:loan_calc_dev/models/saved_index.dart';
import 'package:loan_calc_dev/provider/animation_provider.dart';
import 'package:loan_calc_dev/storage/input_tracker_storage.dart';
import 'package:loan_calc_dev/storage/precision_storage.dart';
import 'package:loan_calc_dev/text_controller/text_controller.dart';

class Calculation extends ChangeNotifier {
  AnimationProvider animationProvider;
  TextController _textController;
  ShowDialogs showDialogs;

  double _payment = 0.0;
  double _amount = 0.0;
  double _percent = 0.0;
  double _months = 0.0;
  double _roundedPayment = 0.0;
  double _finalPayment = 0.0;

  bool isChangeTime = false;
  bool isRoundUp = false;
  bool isRoundDown = false;

  bool get isTooSmall => (_amount * _percent) >= roundDown(_payment, precision);

  set textController(TextController textController) {
    _textController = textController;
    _textController.amount = TextEditingController()
      ..addListener(_amountAdder);
    _textController.percent = TextEditingController()
      ..addListener(_percentAdder);
    _textController.month = TextEditingController()
      ..addListener(_monthAdder);
  }

  final mbdList = <MonthlyBreakDown>[];

  final savedIndex = SavedIndex();

  final formKey = GlobalKey<FormState>();

  final inputTrackerStorage = InputTrackerStorage();

  List<InputTracker> get iptList => inputTrackerStorage.iptList;

  final precisionStorage = PrecisionStorage();

  int get precision => precisionStorage.precision;

  set precision(int val) {
    precisionStorage.precision = val;
    incrementCounter();
  }

  void update() {
    notifyListeners();
  }

  void incrementCounter() async {
    bool isFormValid = formKey?.currentState?.validate() ?? false;
    savedIndex.reset();
    if (_amount == 0.0 || _percent == 0.0 || _months == 0.0 || !isFormValid) {
      animationProvider?.monthAnimationController?.reverse();
      animationProvider?.finalAnimationController?.reverse();
      _payment = 0.0;
      isRoundUp = false;
      isRoundDown = false;
      notifyListeners();
    } else {
      showDialogs.requestFocus();
      await inputTrackerStorage.handleAddToInputTracker(InputTracker(
        amount: _amount,
        month: _months,
        percent: _percent,
      ));
      animationProvider?.monthAnimationController?.forward();
      _payment = (_percent * _amount) / (1 - pow((1 + _percent), (-_months)));
      if (isRoundDown && isTooSmall) {
        showDialogs.ooops(_payment, _amount * _percent, precision);
        isRoundDown = false;
        animationProvider?.finalAnimationController?.reverse();
      }
      notifyListeners();
      if (isRoundDown || isRoundUp) {
        paymentRounder();
      }
    }
  }

  void amortizer() {
    mbdList.clear();
    double amountTemp = _amount;
    double intTracker = 0.0;
    double princTracker = 0.0;
    double interest = 0.0;
    double temp = 0.0;
    for (int n = 1; n <= _months; n++) {
      if (_roundedPayment > (amountTemp * _percent)) {
        if (n == _months || (_amount - princTracker) < _roundedPayment) {
          interest = amountTemp * _percent;
          _finalPayment = _amount - princTracker + interest;
          intTracker += interest;
          temp = _finalPayment - interest;
          princTracker += temp;
          mbdList.add(MonthlyBreakDown(
            paidInt: roundToPrecision(interest, precision),
            month: n,
            paidPrinc: roundToPrecision(temp, precision),
            payment: roundToPrecision(_finalPayment, precision),
            totPrinc: roundToPrecision(princTracker, precision),
            totInt: roundToPrecision(intTracker, precision),
          ));
          break;
        } else {
          interest = amountTemp * _percent;
          intTracker += interest;
          temp = _roundedPayment - interest;
          princTracker += temp;
          amountTemp = amountTemp - temp;
          mbdList.add(MonthlyBreakDown(
            paidInt: roundToPrecision(interest, precision),
            month: n,
            paidPrinc: roundToPrecision(temp, precision),
            payment: roundToPrecision(_roundedPayment, precision),
            totPrinc: roundToPrecision(princTracker, precision),
            totInt: roundToPrecision(intTracker, precision),
          ));
        }
      } else {
        _finalPayment = 0.0;
        break;
      }
    }
  }

  void _amountAdder() {
    final String val = _textController.amount.text;
    _amount = double.tryParse(val) ?? 0.0;
  }

  void _percentAdder() {
    final String val = _textController.percent.text;
    _percent = (double.tryParse(val) ?? 0.0) / 1200;
  }

  void _monthAdder() {
    final String val = _textController.month.text;
    _months = double.tryParse(val) ?? 0.0;
  }

  void _yearAdder() {
    final String val = _textController.month.text;
    _months = 12 * (double.tryParse(val) ?? 0.0);
  }

  void timechange(bool input) {
    if (isChangeTime != input) {
      isChangeTime = input;
      notifyListeners();
      if (isChangeTime) {
        _textController?.month?.removeListener(_monthAdder);
        _textController?.month?.addListener(_yearAdder);
        _months *= 12;
      } else {
        _textController?.month?.removeListener(_yearAdder);
        _textController?.month?.addListener(_monthAdder);
        _months /= 12;
      }
    }
  }

  void onCheckUp(bool valUp) {
    savedIndex.reset();
    isRoundUp = valUp;
    isRoundDown = false;
    notifyListeners();
    paymentRounder();
  }

  void onCheckDown(bool valDown) {
    savedIndex.reset();
    isRoundDown = valDown;
    isRoundUp = false;
    if (isRoundDown && isTooSmall) {
      showDialogs.ooops(_payment, _amount * _percent, precision);
      isRoundDown = false;
      animationProvider?.finalAnimationController?.reverse();
    }
    notifyListeners();
    paymentRounder();
  }

  void paymentRounder() {
    if (isRoundDown || isRoundUp) {
      animationProvider?.finalAnimationController?.forward();
      _roundedPayment = isRoundUp
          ? roundUp(_payment, precision)
          : roundDown(_payment, precision);
      // Don't remember the test case that warranted this 
      // but generalized it for precision
      if (_roundedPayment == _payment && isRoundUp) {
        _roundedPayment += 1 / pow(10, precision);
      }
    } else {
      animationProvider?.finalAnimationController?.reverse();
    }
    amortizer();
  }

  String monthlyPayment() {
    if (isRoundUp || isRoundDown) {
      return _roundedPayment.toStringAsFixed(precision);
    }
    if (_payment == 0) {
      return '';
    } else {
      return _payment.toStringAsFixed(precision + 3);
    }
  }

  String finalPayment() {
    if (isRoundUp || isRoundDown) {
      return _finalPayment.toStringAsFixed(precision);
    }
    return '';
  }

  void assignTextControllers(InputTracker input) {
    _textController.amount.text = '${input.amount}';
    _textController.percent.text = '${input.percent * 1200}';
    _textController.month.text =
        isChangeTime ? '${input.month / 12}' : '${input.month}';
  }
}
