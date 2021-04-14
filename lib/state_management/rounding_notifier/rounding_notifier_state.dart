class RoundingState {
  RoundingState({
    this.precisePayment,
    this.roundedPayment,
    this.precision,
    this.roundUp = false,
    this.roundDown = false,
    this.isEditing = false,
  }) : payment = roundUp || roundDown ? roundedPayment : precisePayment;

  final double? precisePayment;
  final double? roundedPayment;
  final double? payment;
  final int? precision;
  final bool roundUp;
  final bool roundDown;
  final bool isEditing;

  String monthlyPayment() {
    if (roundUp || roundDown) {
      return roundedPayment!.toStringAsFixed(precision!);
    }
    if (payment == null) {
      return '';
    } else {
      return payment!.toStringAsFixed(precision! + 3);
    }
  }

  RoundingState updateEditing({required bool isEditing}) {
    return RoundingState(
      precisePayment: precisePayment,
      roundedPayment: roundedPayment,
      precision: precision,
      roundUp: roundUp,
      roundDown: roundDown,
      isEditing: isEditing,
    );
  }

  RoundingState copyWith({
    double? precisePayment,
    double? roundedPayment,
    int? precision,
    bool? roundUp,
    bool? roundDown,
  }) {
    return RoundingState(
      precisePayment: precisePayment ?? this.precisePayment,
      roundedPayment: roundedPayment,
      precision: precision ?? this.precision,
      roundUp: roundUp ?? this.roundUp,
      roundDown: roundDown ?? this.roundDown,
    );
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RoundingState &&
        o.precisePayment == precisePayment &&
        o.roundedPayment == roundedPayment &&
        o.payment == payment &&
        o.precision == precision &&
        o.roundUp == roundUp &&
        o.roundDown == roundDown &&
        o.isEditing == isEditing;
  }

  @override
  int get hashCode {
    return precisePayment.hashCode ^
        roundedPayment.hashCode ^
        payment.hashCode ^
        precision.hashCode ^
        roundUp.hashCode ^
        roundDown.hashCode ^
        isEditing.hashCode;
  }
}
