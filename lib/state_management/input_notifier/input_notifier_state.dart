import 'package:loan_calc_dev/state_management/input_notifier/input_notifier_sub_states/amount_state.dart';
import 'package:loan_calc_dev/state_management/input_notifier/input_notifier_sub_states/length_state.dart';
import 'package:loan_calc_dev/state_management/input_notifier/input_notifier_sub_states/percent_state.dart';

class InputState {
  InputState({
    required this.amountState,
    required this.percentState,
    required this.lengthState,
    this.changeTime = false,
  }) : canSubmit = amountState.canSubmit && percentState.canSubmit && lengthState.canSubmit;

  final AmountState amountState;
  final PercentState percentState;
  final LengthState lengthState;
  final bool changeTime;
  final bool canSubmit;

  InputState.initial(int precision)
      : this(
          amountState: AmountState(input: '', precision: precision),
          percentState: PercentState(input: ''),
          lengthState: MonthState(input: ''),
        );

  double get amount => amountState.value!;
  String get amountString => amountState.stringValue!;
  String? get amountError => amountState.error;

  double get percentForDisplay => percentState.value!;
  double get percentForMath => percentForDisplay / 1200;
  String get percentString => percentState.stringValue!;
  String? get percentError => percentState.error;

  int get length => lengthState.value!;
  String get lengthString => lengthState.stringValue!;
  String? get lengthError => lengthState.error;

  int get precision => amountState.precision;

  // InputState updateAmount({required String input, int? precision}) {
  //   return InputState(
  //     amountState: AmountState(input: input, precision: precision ?? this.precision),
  //     percentState: percentState,
  //     lengthState: lengthState,
  //     changeTime: changeTime,
  //   );
  // }

  // InputState updatePercent({required String input}) {
  //   return InputState(
  //     amountState: amountState,
  //     percentState: PercentState(input: input),
  //     lengthState: lengthState,
  //     changeTime: changeTime,
  //   );
  // }

  // InputState updateLength({required String input, bool? changeTime}) {
  //   final lengthState = changeTime ?? this.changeTime ? YearState(input: input) : MonthState(input: input);
  //   return InputState(
  //     amountState: amountState,
  //     percentState: percentState,
  //     lengthState: lengthState,
  //     changeTime: changeTime ?? this.changeTime,
  //   );
  // }

  InputState copyWith({
    String? amountInput,
    String? percentInput,
    String? lengthInput,
    bool? changeTime,
    int? precision,
  }) {
    assert((){
      if(precision != null && amountInput == null){
        return false;
      }
      return true;
    }(),'assert amount value with precision to update validation');
    assert((){
      if(changeTime != null && lengthInput == null){
        return false;
      }
      return true;
    }(),'assert length value with changeTime to update validation');

    AmountState? amountState;
    if (amountInput != null) {
      amountState = AmountState(input: amountInput, precision: precision ?? this.precision);
    }

    PercentState? percentState;
    if (percentInput != null) {
      percentState = PercentState(input: percentInput);
    }

    final newChangeTime = changeTime ?? this.changeTime;

    LengthState? lengthState;
    if (lengthInput != null) {
      lengthState = newChangeTime ? YearState(input: lengthInput) : MonthState(input: lengthInput);
    }
    return InputState(
      amountState: amountState ?? this.amountState,
      percentState: percentState ?? this.percentState,
      lengthState: lengthState ?? this.lengthState,
      changeTime: newChangeTime,
    );
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is InputState &&
        o.amountState == amountState &&
        o.percentState == percentState &&
        o.lengthState == lengthState &&
        o.changeTime == changeTime &&
        o.canSubmit == canSubmit;
  }

  @override
  int get hashCode {
    return amountState.hashCode ^
        percentState.hashCode ^
        lengthState.hashCode ^
        changeTime.hashCode ^
        canSubmit.hashCode;
  }
}
