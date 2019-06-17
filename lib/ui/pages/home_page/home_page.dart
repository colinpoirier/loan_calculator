import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loan_calc_dev/models/data_classes.dart';
import 'package:loan_calc_dev/models/saved_index.dart';
import 'package:loan_calc_dev/provider/theme_provider.dart';
import 'package:loan_calc_dev/ui/helper_widgets/home_page/home_page_helper_widgets.dart';
import 'package:loan_calc_dev/ui/helper_widgets/rounded_appbar.dart';
import 'package:loan_calc_dev/ui/pages/home_page/main_widgets/home_page_widgets.dart';
import 'package:loan_calc_dev/ui/themes/themes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _counter = 0.0;
  double _amount = 0.0;
  double _percent = 0.0;
  double _months = 0.0;
  double _resultheight = 0.0;
  double _resultwidth = 0.0;
  double _endheight = 0.0;
  double _endwidth = 0.0;
  double _paymentTemp = 0.0;
  double _finalPaymentTemp = 0.0;

  bool _changeTime = false;
  bool _roundUp = false;
  bool _roundDown = false;

  static const Duration expandedDuration = Duration(milliseconds: 300);
  static const String prefsKey = 'inputHistory';

  String calChange = '';

  List<InputTracker> iptList = [];

  final mbdList = <MonthlyBreakDown>[];

  final savedIndex = SavedIndex();

  TextEditingController amountController;
  TextEditingController percentController;
  TextEditingController monthController;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController()
      ..addListener(() => _amountAdder(amountController.text));
    percentController = TextEditingController()
      ..addListener(() => _percentAdder(percentController.text));
    monthController = TextEditingController()
      ..addListener(() => _monthAdder(monthController.text));
    loadIptList();
  }

  @override
  void dispose() {
    super.dispose();
    amountController.dispose();
    percentController.dispose();
    monthController.dispose();
  }

  void _incrementCounter() async {
    bool formValid = formKey?.currentState?.validate() ?? false;
    savedIndex.reset();
    if (_amount == 0.0 || _percent == 0.0 || _months == 0.0 || !formValid) {
      setState(() {
        _counter = 0.0;
        _resultheight = 0.0;
        _resultwidth = 0.0;
        finalPaymentCardShrinker();
        _roundUp = false;
        _roundDown = false;
      });
    } else {
      FocusScope.of(context).requestFocus(FocusNode());
      await handleAddToInputTracker(InputTracker(
        amount: _amount,
        month: _months,
        percent: _percent,
      ));
      setState(() {
        _resultheight = 177.0;
        _resultwidth = MediaQuery.of(context).size.width;
        _counter = (_percent * _amount) / (1 - pow((1 + _percent), (-_months)));
        if ((_amount * _percent) >= roundThisDown(_counter) && _roundDown) {
          ooops(context);
          _roundDown = false;
          finalPaymentCardShrinker();
        }
      });
      if (_roundDown || _roundUp) {
        hi();
      }
    }
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
    preferences.setString(prefsKey, jsonEncode(iptJsonList));
  }

  void loadIptList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final jsonString = preferences.getString(prefsKey);
    if (jsonString != null) {
      final json = jsonDecode(jsonString);
      iptList =
          json.map<InputTracker>((obj) => InputTracker.fromJson(obj)).toList();
      setState(() {});
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
              paidInt: roundToTwo(interest),
              month: n,
              paidPrinc: roundToTwo(temp),
              payment: roundToTwo(_finalPaymentTemp),
              totPrinc: roundToTwo(princTracker),
              totInt: roundToTwo(intTracker)));
          break;
        } else {
          interest = amountTemp * _percent;
          intTracker += interest;
          temp = _paymentTemp - interest;
          princTracker += temp;
          amountTemp = amountTemp - temp;
          mbdList.add(MonthlyBreakDown(
              paidInt: roundToTwo(interest),
              month: n,
              paidPrinc: roundToTwo(temp),
              payment: roundToTwo(_paymentTemp),
              totPrinc: roundToTwo(princTracker),
              totInt: roundToTwo(intTracker)));
        }
      } else {
        _finalPaymentTemp = 0.0;
        break;
      }
    }
  }

  Future ooops(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Oops'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Payment would be less than or equal\nto first month\'s interest.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                    '${roundThisDown(_counter)} ≤ ${(_amount * _percent).toStringAsFixed(5)}')
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text(
                  'Go back',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
    );
  }

  void _amountAdder(String val) {
    _amount = double.tryParse(val) ?? 0.0;
  }

  void _percentAdder(String val) {
    _percent = (double.tryParse(val) ?? 0.0) / 1200;
  }

  void _monthAdder(String val) {
    _months = double.tryParse(val) ?? 0.0;
    if (_changeTime && calChange == 'Years') {
      _months *= 12;
    }
  }

  void _timechange(String value) {
    calChange = value;
    if (value == 'Years' && _changeTime == false) {
      setState(() {
        _changeTime = true;
      });
      if (_months != 0) {
        _monthAdder((_months).toString());
      }
    } else if (value == 'Months' && _changeTime == true) {
      setState(() {
        _changeTime = false;
      });
      if (_months != 0) {
        _monthAdder((_months /= 12).toString());
      }
    }
  }

  void finalPaymentCardShrinker() {
    _endheight = 0.0;
    _endwidth = 0.0;
  }

  void finalPaymentCardGrower() {
    _endheight = 110.0;
    _endwidth = MediaQuery.of(context).size.width;
  }

  void onCheckUp(bool valUp) {
    savedIndex.reset();
    setState(() {
      _roundUp = valUp;
      _roundDown = false;
    });
    hi();
  }

  void onCheckDown(bool valDown) {
    savedIndex.reset();
    setState(() {
      _roundDown = valDown;
      _roundUp = false;
      if ((_amount * _percent) >= roundThisDown(_counter) && _roundDown) {
        ooops(context);
        _roundDown = false;
        finalPaymentCardShrinker();
      }
    });
    hi();
  }

  void hi() {
    if (_roundDown || _roundUp) {
      finalPaymentCardGrower();
      _paymentTemp = _roundUp ? roundThisUp(_counter) : roundThisDown(_counter);
    } else {
      finalPaymentCardShrinker();
    }
    amortizer();
  }

  double roundThisUp(double val) => (val * 100).ceilToDouble() / 100;

  double roundThisDown(double val) => (val * 100).floorToDouble() / 100;

  double roundToTwo(double val) => (val * 100).roundToDouble() / 100;

  String monthlyPayment() {
    if (_roundUp || _roundDown) {
      return _paymentTemp.toStringAsFixed(2);
    }
    if (_counter == 0) {
      return '';
    } else {
      return _counter.toStringAsFixed(5);
    }
  }

  String finalPayment() {
    if (_roundUp || _roundDown) {
      return _finalPaymentTemp.toStringAsFixed(2);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeChange = Provider.of<ThemeProvider>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      onLongPress: () => themeChange.getTheme == CalcThemes.lightTheme
          ? themeChange.setTheme(CalcThemes.darkTheme)
          : themeChange.setTheme(CalcThemes.lightTheme),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: RoundedAppBar(
          child: Text(
            'LoanCalc',
            style: theme.textTheme.title
                .copyWith(fontSize: 40, fontWeight: FontWeight.normal),
          ),
        ),
        body: Center(
          child: Scroller.column(
            children: <Widget>[
              MyCard(
                child: Input(
                  formKey: formKey,
                  amountController: amountController,
                  percentController: percentController,
                  monthController: monthController,
                  timeChange: _timechange,
                  changeTime: _changeTime,
                ),
              ),
              RaisedButton(
                onPressed: _incrementCounter,
                elevation: 4.0,
                color: theme.primaryColor,
                shape: const StadiumBorder(
                  side: BorderSide(
                    color: Colors.black38,
                  ),
                ),
                child: const Text(
                  'CALCULATE',
                  style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              MyCard(
                child: MonthlyPaymentResult(
                  resultHeight: _resultheight,
                  resultWidth: _resultwidth,
                  expandedDuration: expandedDuration,
                  roundUp: _roundUp,
                  roundDown: _roundDown,
                  onCheckUp: onCheckUp,
                  onCheckDown: onCheckDown,
                  monthlyPayment: monthlyPayment(),
                ),
              ),
              MyCard(
                child: FinalPayment(
                  endHeight: _endheight,
                  endWidth: _endwidth,
                  expandedDuration: expandedDuration,
                  finalPayment: finalPayment(),
                  mbdList: mbdList,
                  iptList: iptList,
                  savedIndex: savedIndex,
                ),
              ),
            ],
          ),
        ),
        drawer: HistoryDrawer(
          setState: () async {
            await saveIptList();
            setState(() {});
          },
          changeTime: _changeTime,
          iptList: iptList,
          amountController: amountController,
          percentController: percentController,
          monthController: monthController,
        ),
      ),
    );
  }
}
