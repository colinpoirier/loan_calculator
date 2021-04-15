import 'package:loan_calc_dev/state_management/input_notifier/input_notifier_sub_states/sub_state.dart';

abstract class LengthState extends SubState{
  LengthState._({this.value, String? monthsString, String? error}) : super(value: value, stringValue: monthsString, error: error);
  
  @override
  final int? value;

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is LengthState &&
      o.value == value &&
      o.stringValue == stringValue &&
      o.error == error &&
      o.canSubmit == canSubmit;
  }

  @override
  int get hashCode => value.hashCode ^ stringValue.hashCode ^ error.hashCode ^ canSubmit.hashCode;
}

class MonthState extends LengthState {
  static const _maxMonths = 600;
  static const _minMonths = 1;

  factory MonthState({required String input}){
    if (input.isEmpty) {
      return MonthState._();
    }
    final parsed = int.tryParse(input);
    if (parsed == null) {
      return MonthState._(error: 'Please enter a number');
    } else if (parsed < _minMonths || parsed > _maxMonths) {
      return MonthState._(error: '$_minMonths - $_maxMonths');
    } else {
      return MonthState._(months: parsed, monthsString: input);
    }
  }

  MonthState._({int? months, String? monthsString, String? error}) : super._(value: months, monthsString: monthsString, error: error);

}

class YearState extends LengthState {
  static const _maxYears = MonthState._maxMonths / 12.0;
  static const _minYears = MonthState._minMonths / 12.0;

  factory YearState({required String input}) {
    if (input.isEmpty) {
      return YearState._();
    }
    final parsed = double.tryParse(input);
    if (parsed == null) {
      return YearState._(error: 'Please enter a number');
    } else if (parsed < _minYears || parsed > _maxYears) {
      return YearState._(error: '${_minYears.toStringAsFixed(5)} - $_maxYears');
    } else if (parsed * 12 % 1 != 0) {
      return YearState._(error: 'Not a whole month');
    } else {
      final int months = parsed ~/ 1 * 12;
      return YearState._(months: months, monthsString: '$months');
    }
  }

  YearState._({int? months, String? monthsString, String? error}) : super._(value: months, monthsString: monthsString, error: error);

}

