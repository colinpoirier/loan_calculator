import 'package:flutter/material.dart';
import 'package:loan_calc_dev/storage/precision/precision_storage.dart';

class PrecisionNotifier extends ChangeNotifier {
  PrecisionNotifier(this.precisionStorage);

  final PrecisionStorage precisionStorage;

  int get precision => precisionStorage.precision;

  void updatePrecision(int precision) async {
    await precisionStorage.setPrecision(precision);
    notifyListeners();
  }


}