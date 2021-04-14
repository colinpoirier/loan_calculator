import 'dart:math';

import 'package:loan_calc_dev/state_management/input_notifier/input_notifier_sub_states/sub_state.dart';

class AmountState extends SubState {

  static const _maxAmount = 10000000; 

  factory AmountState({required String input, required int precision}){
    if (input.isEmpty) {
      return AmountState._(precision: precision);
    }

    final parsed = double.tryParse(input);
    if (parsed == null) {
      return AmountState._(error: 'Please enter a number', precision: precision);
    }
    final minVal = pow(10, -precision);
    if (parsed < minVal || parsed > _maxAmount) {
      return AmountState._(error: '$minVal - $_maxAmount', precision: precision);
    } 
    
    final parts = input.split('.');
    if (parts.length == 2 && parts[1].length > precision && parts[1].contains(RegExp(r'[1-9]+'))) {
      return AmountState._(error: 'Check precision', precision: precision);
    }
    return AmountState._(amount: parsed, amountString: input, precision: precision);
  }

  AmountState._({double? amount, String? amountString, String? error, required this.precision}): super(value: amount, stringValue: amountString, error: error);

  final int precision;

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is AmountState &&
      o.value == value &&
      o.stringValue == stringValue &&
      o.error == error &&
      o.precision == precision &&
      o.canSubmit == canSubmit;
  }

  @override
  int get hashCode => value.hashCode^ stringValue.hashCode ^ error.hashCode ^ precision.hashCode ^ canSubmit.hashCode;  
}