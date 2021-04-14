import 'package:flutter/cupertino.dart';
import 'package:loan_calc_dev/models/data_classes.dart';
import 'package:loan_calc_dev/state_management/calculation_notifier/calculation_notifier.dart';
import 'package:loan_calc_dev/state_management/input_notifier/input_notifier_state.dart';
import 'package:loan_calc_dev/storage/precision/precision_notifier.dart';
import 'package:loan_calc_dev/convience_classes/text_controller.dart';

class InputNotifier extends CalcNotifier<InputState> {
  InputNotifier({required PrecisionNotifier precisionNotifier})
      : _textController = TextController(),
        super(InputState.initial(precisionNotifier.precision)) {
    amount.addListener(amountChange);
    percent.addListener(percentChange);
    length.addListener(lengthChange);
    precisionNotifier.addListener(() {
      if (state.precision != precisionNotifier.precision) {
        setState(state.copyWith(amountInput: amount.text, precision: precisionNotifier.precision));
      }
    });
  }

  final TextController _textController;
  TextEditingController get amount => _textController.amount;
  TextEditingController get percent => _textController.percent;
  TextEditingController get length => _textController.month;

  void amountChange() {
    setState(state.copyWith(amountInput: amount.text));
  }

  void percentChange() {
    setState(state.copyWith(percentInput: percent.text));
  }

  void lengthChange() {
    setState(state.copyWith(lengthInput: length.text));
  }

  void changeTimechange(bool input) {
    setState(state.copyWith(lengthInput: length.text, changeTime: input));
  }

  void setControllerInputs(InputTracker ipt) {

    // amount.text = ipt.amount;

    // percent.text = ipt.percent;
    // num months = int.parse(ipt.month);
    // if (state.changeTime){
    //   months /= 12;
    // }
//TODO save string and num. compare only num
    // length.text = state.changeTime ? '${months / 12}' : '$months';
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
