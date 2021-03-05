import 'dart:async';

import 'package:loan_calc_dev/ui/route_generator/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrecisionStorage {
  int _precision = 2;

  int get precision => _precision;

  Future setPrecision(int val) async {
    _precision = val;
    await savePrecision();
  }

  Future savePrecision() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(SC.precisionPrefsKey, _precision);
  }

  void loadPrecision() async {
    final preferences = await SharedPreferences.getInstance();
    final precision = preferences.getInt(SC.precisionPrefsKey);
    if (precision != null) {
      _precision = precision;
    }
  }
}
