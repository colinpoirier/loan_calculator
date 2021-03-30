import 'dart:async';

import 'package:loan_calc_dev/ui/route_generator/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrecisionStorage {

  PrecisionStorage(this.preferences);

  final SharedPreferences preferences;

  int _precision = 2;

  int get precision => _precision;

  Future<void> setPrecision(int val) async {
    _precision = val;
    await savePrecision();
  }

  Future<void> savePrecision() async {
    await preferences.setInt(SC.precisionPrefsKey, _precision);
  }

  void loadPrecision() {
    final precision = preferences.getInt(SC.precisionPrefsKey);
    if (precision != null) {
      _precision = precision;
    }
  }
}
