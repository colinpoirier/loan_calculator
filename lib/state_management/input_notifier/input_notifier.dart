import 'package:flutter/cupertino.dart';
import 'package:loan_calc_dev/models/data_classes.dart';
import 'package:loan_calc_dev/state_management/calculation_notifier/calculation_notifier.dart';
import 'package:loan_calc_dev/state_management/input_notifier/input_notifier_state.dart';
import 'package:loan_calc_dev/storage/precision/precision_notifier.dart';
import 'package:loan_calc_dev/convience_classes/text_controller.dart';

class InputNotifier extends CalcNotifier<InputState> {
  InputNotifier({required PrecisionNotifier precisionNotifier})
      : _textController = TextController(),
        super(InputState(precision: precisionNotifier.precision)) {
    amount.addListener(amountChange);
    percent.addListener(percentChange);
    length.addListener(lengthChangeMonths);
    precisionNotifier.addListener(() {
      if (state.precision != precisionNotifier.precision) {
        setState(state.updatePrecision(precision: precisionNotifier.precision));
        amountChange();
      }
    });
  }

  final TextController _textController;
  TextEditingController get amount => _textController.amount;
  TextEditingController get percent => _textController.percent;
  TextEditingController get length => _textController.month;

  void amountChange() {
    final val = amount.text;
    if (val.isEmpty) {
      setState(state.updateAmount());
      return;
    }
    final parts = val.split('.');
    if (parts.length == 2 && parts[1].length > state.precision) {
      setState(state.updateAmount(amountError: 'check precision'));
      return;
    }
    final parsed = double.tryParse(val);
    if (parsed == null) {
      setState(state.updateAmount(amountError: 'not a number'));
    } else if (parsed < 0 || parsed > 10000000) {
      setState(state.updateAmount(amountError: 'range'));
    } else {
      setState(state.updateAmount(amount: parsed));
    }
  }

  void percentChange() {
    final val = percent.text;
    if (val.isEmpty) {
      setState(state.updatePercent());
      return;
    }
    final parsed = double.tryParse(val);
    if (parsed == null) {
      setState(state.updatePercent(percentError: 'not a number'));
    } else if (parsed < 0 || parsed > 100) {
      setState(state.updatePercent(percentError: 'range'));
    } else {
      setState(state.updatePercent(percent: parsed / 1200));
    }
  }

  void lengthChangeMonths() {
    final val = length.text;
    if (val.isEmpty) {
      setState(state.updateLength());
      return;
    }
    final parsed = int.tryParse(val);
    if (parsed == null) {
      setState(state.updateLength(lengthError: 'not a number month'));
    } else if (parsed < 0 || parsed > 600) {
      setState(state.updateLength(lengthError: 'range'));
    } else {
      setState(state.updateLength(length: parsed.toDouble()));
    }
  }

  void lengthChangeYears() {
    final val = length.text;
    if (val.isEmpty) {
      setState(state.updateLength());
      return;
    }
    final parsed = double.tryParse(val);
    if (parsed == null) {
      setState(state.updateLength(lengthError: 'not a number'));
    } else if (parsed < 0 || parsed > 50) {
      setState(state.updateLength(lengthError: 'range'));
    } else if (parsed * 12 % 1 != 0) {
      setState(state.updateLength(lengthError: 'not whole month'));
    } else {
      setState(state.updateLength(length: parsed * 12));
    }
  }

  void changeTimechange(bool input) {
    final isChangeTime = state.changeTime;
    if (isChangeTime != input) {
      setState(state.updateChangeTime(changeTime: input));
      if (state.changeTime) {
        length.removeListener(lengthChangeMonths);
        length.addListener(lengthChangeYears);
        lengthChangeYears();
      } else {
        length.removeListener(lengthChangeYears);
        length.addListener(lengthChangeMonths);
        lengthChangeMonths();
      }
    }
  }

  void setControllerInputs(InputTracker ipt) {
    if (ipt.amount % 1 == 0) {
      amount.text = '${ipt.amount.toInt()}';
    } else {
      amount.text = '${ipt.amount}';
    }
    final iptPercent = ipt.percent * 1200;
    if (iptPercent % 1 == 0) {
      percent.text = '${iptPercent.toInt()}';
    } else {
      percent.text = '$iptPercent';
    }
    length.text = state.changeTime ? '${ipt.month / 12}' : '${ipt.month.toInt()}';
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
