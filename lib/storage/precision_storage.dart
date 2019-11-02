import 'dart:async';

import 'package:loan_calc_dev/ui/route_generator/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrecisionStorage {
  int _precision;

  int get precision => _precision;

  set precision(int val) {
    _precision = val;
    savePrecision();
  }

  Future savePrecision() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(SC.precisionPrefsKey, _precision);
  }

  void loadPrecision() async {
    final preferences = await SharedPreferences.getInstance();
    _precision = preferences.getInt(SC.precisionPrefsKey) ?? 2;
  }
}
