import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:loan_calc_dev/calculation/utils.dart';
import 'package:loan_calc_dev/dialogs/dialogs.dart';
import 'package:loan_calc_dev/models/data_classes.dart';
import 'package:loan_calc_dev/models/saved_index.dart';
import 'package:loan_calc_dev/provider/animation_provider.dart';
import 'package:loan_calc_dev/text_controller/text_controller.dart';
import 'package:loan_calc_dev/ui/route_generator/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Calculation extends ChangeNotifier{

  AnimationProvider animationProvider;
  TextController _textController;
  ShowDialogs showOoopsDialog;

  double _counter = 0.0;
  double _amount = 0.0;
  double _percent = 0.0;
  double _months = 0.0;
  double _paymentTemp = 0.0;
  double _finalPaymentTemp = 0.0;

  bool changeTime = false;
  bool roundUp = false;
  bool roundDown = false;  

  int _precision;

  int get precision => _precision;

  set precision(int val){
    _precision = val;
    // notifyListeners();
    incrementCounter();
    savePrecision();
  }

  set textController(TextController textController){
    _textController = textController;
    _textController.amount = TextEditingController()..addListener(() => _amountAdder(_textController.amount.text));
    _textController.percent = TextEditingController()..addListener(() => _percentAdder(_textController.percent.text));
    _textController.month = TextEditingController()..addListener(() => _monthAdder(_textController.month.text));

  }

  List<InputTracker> iptList = [];

  final mbdList = <MonthlyBreakDown>[];

  final savedIndex = SavedIndex();

  final formKey = GlobalKey<FormState>();

  void update(){
    notifyListeners();
  }

  void incrementCounter() async {
    bool formValid = formKey?.currentState?.validate() ?? false;
    savedIndex.reset();
    if (_amount == 0.0 || _percent == 0.0 || _months == 0.0 || !formValid) {
      animationProvider?.monthAnimationController?.reverse();
      animationProvider?.finalAnimationController?.reverse();
      // setState(() {
        _counter = 0.0;
        roundUp = false;
        roundDown = false;
      // });
      notifyListeners();
    } else {
      showOoopsDialog.requestFocus();
      await handleAddToInputTracker(InputTracker(
        amount: _amount,
        month: _months,
        percent: _percent,
      ));
      animationProvider?.monthAnimationController?.forward();
      // setState(() {
        _counter = (_percent * _amount) / (1 - pow((1 + _percent), (-_months)));
        if ((_amount * _percent) >= roundThisDown(_counter, _precision) && roundDown) {
          showOoopsDialog.ooops(_counter, _amount, _percent, _precision);
          roundDown = false;
          animationProvider?.finalAnimationController?.reverse();
        }
      // });
      notifyListeners();
      if (roundDown || roundUp) {
        hi();
      }
    }
  }

  Future savePrecision() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(SC.precisionPrefsKey, _precision);
  }

  void loadPrecision() async {
    final preferences = await SharedPreferences.getInstance();
    precision = preferences.getInt(SC.precisionPrefsKey) ?? 2;
  }

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
      // setState(() {});
      notifyListeners();
    }
  }

  void amortizer() {
    mbdList.clear();
    double amountTemp = _amount;
    double intTracker = 0.0;
    double princTracker = 0.0;
    double interest = 0.0;
    double temp = 0.0;
    for (int n = 1; n <= _months; n++) {
      if (_paymentTemp > (amountTemp * _percent)) {
        if (n == _months || (_amount - princTracker) < (_paymentTemp)) {
          interest = amountTemp * _percent;
          _finalPaymentTemp = _amount - princTracker + interest;
          intTracker += interest;
          temp = _finalPaymentTemp - interest;
          princTracker += temp;
          mbdList.add(MonthlyBreakDown(
              paidInt: roundToTwo(interest, _precision),
              month: n,
              paidPrinc: roundToTwo(temp, _precision),
              payment: roundToTwo(_finalPaymentTemp, _precision),
              totPrinc: roundToTwo(princTracker, _precision),
              totInt: roundToTwo(intTracker, _precision)));
          break;
        } else {
          interest = amountTemp * _percent;
          intTracker += interest;
          temp = _paymentTemp - interest;
          princTracker += temp;
          amountTemp = amountTemp - temp;
          mbdList.add(MonthlyBreakDown(
              paidInt: roundToTwo(interest, _precision),
              month: n,
              paidPrinc: roundToTwo(temp, _precision),
              payment: roundToTwo(_paymentTemp, _precision),
              totPrinc: roundToTwo(princTracker, _precision),
              totInt: roundToTwo(intTracker, _precision)));
        }
      } else {
        _finalPaymentTemp = 0.0;
        break;
      }
    }
  }


  void _amountAdder(String val) {
    _amount = double.tryParse(val) ?? 0.0;
  }

  void _percentAdder(String val) {
    _percent = (double.tryParse(val) ?? 0.0) / 1200;
  }

  void _monthAdder(String val) {
    _months = double.tryParse(val) ?? 0.0;
  }

  void _yearAdder(String val) {
    _months = 12 * (double.tryParse(val) ?? 0.0);
  }

  void timechange(bool input) {
    if(changeTime != input){
      // setState(() {
      changeTime = input;
    // });
      notifyListeners();
      if (changeTime) {
        _textController?.month?.removeListener(() => _monthAdder);
        _textController?.month?.addListener(() => _yearAdder(_textController?.month?.text));
        _months *= 12;
      } else {
        _textController?.month?.removeListener(() => _yearAdder);
        _textController?.month?.addListener(() => _monthAdder(_textController?.month?.text));
        _months /= 12;
      }
    }
  }

  void onCheckUp(bool valUp) {
    savedIndex.reset();
    // setState(() {
      roundUp = valUp;
      roundDown = false;
    // });
    notifyListeners();
    hi();
  }

  void onCheckDown(bool valDown) {
    savedIndex.reset();
    // setState(() {
      roundDown = valDown;
      roundUp = false;
      if ((_amount * _percent) >= roundThisDown(_counter, _precision) && roundDown) {
        showOoopsDialog.ooops(_counter, _amount, _percent, _precision);
        roundDown = false;
        animationProvider?.finalAnimationController?.reverse();
      }
    // });
    notifyListeners();
    hi();
  }

  void hi() {
    if (roundDown || roundUp) {
      animationProvider?.finalAnimationController?.forward();
      _paymentTemp = roundUp ? roundThisUp(_counter, _precision) : roundThisDown(_counter, _precision);
      if (_paymentTemp == _counter && roundUp) _paymentTemp += 0.01;
    } else {
      animationProvider?.finalAnimationController?.reverse();
    }
    amortizer();
  }

  String monthlyPayment() {
    if (roundUp || roundDown) {
      return _paymentTemp.toStringAsFixed(_precision);
    }
    if (_counter == 0) {
      return '';
    } else {
      return _counter.toStringAsFixed(_precision + 3);
    }
  }

  String finalPayment() {
    if (roundUp || roundDown) {
      return _finalPaymentTemp.toStringAsFixed(_precision);
    }
    return '';
  }
}