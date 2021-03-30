import 'package:loan_calc_dev/models/data_classes.dart';

class FinalState {
  FinalState({this.finalPayment, this.mbdList, required this.precision, this.isEditing = false});

  final double? finalPayment;
  final List<MonthlyBreakDown>? mbdList;
  final int precision;
  final bool isEditing;

  String getFinalPayment() {
    if (finalPayment != null) {
      return finalPayment!.toStringAsFixed(precision);
    }
    return '';
  }  

  FinalState copyWith({
    double? finalPayment,
    List<MonthlyBreakDown>? mbdList,
    int? precision,
    bool? isEditing,
  }) {
    return FinalState(
      finalPayment: finalPayment ?? this.finalPayment,
      mbdList: mbdList ?? this.mbdList,
      precision: precision ?? this.precision,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}
