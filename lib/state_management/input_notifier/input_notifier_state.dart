class InputState {
  InputState({
    this.amount,
    this.percent,
    this.length,
    this.amountError,
    this.percentError,
    this.lengthError,
    this.changeTime = false,
    required this.precision,
  }) : canSubmit = amountError == null && percentError == null && lengthError == null && amount != null && percent != null && length != null;

  final double? amount;
  final double? percent;
  final double? length;
  final String? amountError;
  final String? percentError;
  final String? lengthError;
  final bool changeTime;
  final bool canSubmit;
  final int precision;

  InputState updateAmount({double? amount, String? amountError}) {
    return InputState(
      amount: amount,
      percent: percent,
      length: length,
      amountError: amountError,
      percentError: percentError,
      lengthError: lengthError,
      changeTime: changeTime,  
      precision: precision,    
    );
  }
  
  InputState updatePercent({double? percent, String? percentError}) {
    return InputState(
      amount: amount,
      percent: percent,
      length: length,
      amountError: amountError,
      percentError: percentError,
      lengthError: lengthError,
      changeTime: changeTime,      
      precision: precision,    
    );
  }

  InputState updateLength({double? length, String? lengthError}) {
    return InputState(
      amount: amount,
      percent: percent,
      length: length,
      amountError: amountError,
      percentError: percentError,
      lengthError: lengthError,
      changeTime: changeTime,      
      precision: precision,    
    );
  }

  InputState updateChangeTime({required bool changeTime}) {
    return InputState(
      amount: amount,
      percent: percent,
      length: length,
      amountError: amountError,
      percentError: percentError,
      lengthError: lengthError,
      changeTime: changeTime,      
      precision: precision,    
    );    
  }

  InputState updatePrecision({required int precision}) {
    return InputState(
      amount: amount,
      percent: percent,
      length: length,
      amountError: amountError,
      percentError: percentError,
      lengthError: lengthError,
      changeTime: changeTime,      
      precision: precision,    
    );    
  }

  @override
  String toString() {
    return 'InputState(amount: $amount, percent: $percent, length: $length, amountError: $amountError, percentError: $percentError, lengthError: $lengthError, changeTime: $changeTime, canSubmit: $canSubmit)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is InputState &&
      o.amount == amount &&
      o.percent == percent &&
      o.length == length &&
      o.amountError == amountError &&
      o.percentError == percentError &&
      o.lengthError == lengthError &&
      o.changeTime == changeTime &&
      o.canSubmit == canSubmit &&
      o.precision == precision;
  }

  @override
  int get hashCode {
    return amount.hashCode ^
      percent.hashCode ^
      length.hashCode ^
      amountError.hashCode ^
      percentError.hashCode ^
      lengthError.hashCode ^
      changeTime.hashCode ^
      canSubmit.hashCode ^
      precision.hashCode;
  }
}
