import 'dart:convert';

import 'package:loan_calc_dev/models/data_classes.dart';
import 'package:loan_calc_dev/ui/route_generator/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputTrackerStorage{
  List<InputTracker> iptList;

  Future handleAddToInputTracker(InputTracker ipt) async {
    if (iptList.contains(ipt)) iptList.remove(ipt);
    iptList.insert(0, ipt);
    if (iptList.length > 20) iptList.removeLast();
    await saveIptList();
  }

  Future saveIptList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final iptJsonList = iptList.map((ipt) => ipt.toJson()).toList();
    await preferences.setString(SC.inputPrefsKey, jsonEncode(iptJsonList));
  }

  void loadIptList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final jsonString = preferences.getString(SC.inputPrefsKey);
    if (jsonString != null) {
      final json = jsonDecode(jsonString);
      iptList =
          json.map<InputTracker>((obj) => InputTracker.fromJson(obj)).toList();
    } else {
      iptList = [];
    }
  }
}