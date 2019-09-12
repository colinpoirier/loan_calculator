import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loan_calc_dev/models/data_classes.dart';
import 'package:loan_calc_dev/models/saved_index.dart';
import 'package:loan_calc_dev/provider/theme_provider.dart';
import 'package:loan_calc_dev/ui/helper_widgets/home_page/home_page_helper_widgets.dart';
import 'package:loan_calc_dev/ui/helper_widgets/rounded_appbar.dart';
import 'package:loan_calc_dev/ui/pages/home_page/main_widgets/home_page_widgets.dart';
import 'package:loan_calc_dev/ui/route_generator/string_constants.dart';
import 'package:loan_calc_dev/ui/themes/themes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  double _counter = 0.0;
  double _amount = 0.0;
  double _percent = 0.0;
  double _months = 0.0;
  double _paymentTemp = 0.0;
  double _finalPaymentTemp = 0.0;

  bool _changeTime = false;
  bool _roundUp = false;
  bool _roundDown = false;

  static const Duration expandedDuration = Duration(milliseconds: 300);

  // String calChange = '';

  List<InputTracker> iptList = [];

  final mbdList = <MonthlyBreakDown>[];

  final savedIndex = SavedIndex();

  TextEditingController amountController;
  TextEditingController percentController;
  TextEditingController monthController;

  final formKey = GlobalKey<FormState>();

  AnimationController monthAnimationController;
  AnimationController finalAnimationController;
  Animation<double> monthlyAnimation;
  Animation<double> finalAnimation;

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
    monthAnimationController =
        AnimationController(vsync: this, duration: expandedDuration);
    finalAnimationController =
        AnimationController(vsync: this, duration: expandedDuration);
    monthlyAnimation = CurvedAnimation(
        parent: monthAnimationController, curve: Curves.fastOutSlowIn);
    finalAnimation = CurvedAnimation(
        parent: finalAnimationController, curve: Curves.fastOutSlowIn);
  }

  @override
  void dispose() {
    amountController.dispose();
    percentController.dispose();
    monthController.dispose();
    monthAnimationController.dispose();
    finalAnimationController.dispose();
    super.dispose();
  }

  void _incrementCounter() async {
    bool formValid = formKey?.currentState?.validate() ?? false;
    savedIndex.reset();
    if (_amount == 0.0 || _percent == 0.0 || _months == 0.0 || !formValid) {
      monthAnimationController.reverse();
      finalAnimationController.reverse();
      setState(() {
        _counter = 0.0;
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
      monthAnimationController.forward();
      setState(() {
        _counter = (_percent * _amount) / (1 - pow((1 + _percent), (-_months)));
        if ((_amount * _percent) >= roundThisDown(_counter) && _roundDown) {
          ooops();
          _roundDown = false;
          finalAnimationController.reverse();
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
    await preferences.setString(SC.inputPrefsKey, jsonEncode(iptJsonList));
  }

  void loadIptList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final jsonString = preferences.getString(SC.inputPrefsKey);
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

  Future ooops() async {
    final counterTemp = roundThisDown(_counter).toStringAsFixed(2);
    final interestTemp = (_amount * _percent).toStringAsFixed(5);
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
            Text('$counterTemp ≤ $interestTemp')
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Go back',
              style: TextStyle(color: Theme.of(context).textTheme.body1.color),
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
  }

  void _yearAdder(String val) {
    _months = 12 * (double.tryParse(val) ?? 0.0);
  }
  // void _monthAdder(String val) {
  //   _months = double.tryParse(val) ?? 0.0;
  //   if (_changeTime && calChange == 'Years') {
  //     _months *= 12;
  //   }
  // }

  void _timechange() {
    setState(() {
      _changeTime = !_changeTime;
    });
    if (_changeTime) {
      monthController.removeListener(() => _monthAdder);
      monthController.addListener(() => _yearAdder(monthController.text));
      _months *= 12;
    } else {
      monthController.removeListener(() => _yearAdder);
      monthController.addListener(() => _monthAdder(monthController.text));
      _months /= 12;
    }
  }

  // void _timechange(String value) {
  //   calChange = value;
  //   if (value == 'Years' && _changeTime == false) {
  //     setState(() {
  //       _changeTime = true;
  //     });
  //     if (_months != 0) {
  //       _monthAdder((_months).toString());
  //     }
  //   } else if (value == 'Months' && _changeTime == true) {
  //     setState(() {
  //       _changeTime = false;
  //     });
  //     if (_months != 0) {
  //       _monthAdder((_months /= 12).toString());
  //     }
  //   }
  // }

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
        ooops();
        _roundDown = false;
        finalAnimationController.reverse();
      }
    });
    hi();
  }

  void hi() {
    if (_roundDown || _roundUp) {
      finalAnimationController.forward();
      _paymentTemp = _roundUp ? roundThisUp(_counter) : roundThisDown(_counter);
      if (_paymentTemp == _counter && _roundUp) _paymentTemp += 0.01;
    } else {
      finalAnimationController.reverse();
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      onLongPress: () async {
        final themeChange = Provider.of<ThemeProvider>(context);
        final isDark = themeChange.getTheme == CalcThemes.darkTheme;
        await SharedPreferences.getInstance()
          ..setBool(SC.themePrefsKey, !isDark);
        themeChange
            .setTheme(isDark ? CalcThemes.lightTheme : CalcThemes.darkTheme);
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: RoundedAppBar(
          child: Text(
            'LoanCalc',
            style: theme.textTheme.title.copyWith(
              fontSize: 40,
              fontWeight: FontWeight.normal,
            ),
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
              SizeScaleTransition(
                animation: monthlyAnimation,
                child: MyCard(
                  child: MonthlyPaymentResult(
                    expandedDuration: expandedDuration,
                    roundUp: _roundUp,
                    roundDown: _roundDown,
                    onCheckUp: onCheckUp,
                    onCheckDown: onCheckDown,
                    monthlyPayment: monthlyPayment(),
                  ),
                ),
              ),
              SizeScaleTransition(
                animation: finalAnimation,
                child: MyCard(
                  child: FinalPayment(
                    expandedDuration: expandedDuration,
                    finalPayment: finalPayment(),
                    mbdList: mbdList,
                    iptList: iptList,
                    savedIndex: savedIndex,
                  ),
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
