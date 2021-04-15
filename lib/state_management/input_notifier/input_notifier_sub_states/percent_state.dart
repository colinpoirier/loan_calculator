import 'package:loan_calc_dev/state_management/input_notifier/input_notifier_sub_states/sub_state.dart';

class PercentState extends SubState {

  static const _minPercent = 0.001;
  static const _maxPercent = 100.0;

  factory PercentState({required String input}){
    if (input.isEmpty) {
      return PercentState._();
    }
    final parsed = double.tryParse(input);
    if (parsed == null) {
      return PercentState._(error: 'Please enter number');
    } else if (parsed < _minPercent || parsed > _maxPercent) {
      return PercentState._(error: '$_minPercent - $_maxPercent');
    }   
    return PercentState._(value: parsed, percentString: input);
  }

  @override
  final double? value;

  PercentState._({this.value,String? percentString, String? error}) : super(value: value, stringValue: percentString, error: error);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is PercentState &&
      o.value == value &&
      o.stringValue == stringValue &&
      o.error == error &&
      o.canSubmit == canSubmit;
  }

  @override
  int get hashCode => value.hashCode^ stringValue.hashCode ^ error.hashCode ^ canSubmit.hashCode;
}