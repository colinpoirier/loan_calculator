import 'package:flutter/material.dart';
import 'package:loan_calc_dev/calculation/calculation.dart';
import 'package:loan_calc_dev/dialogs/dialogs.dart';
import 'package:loan_calc_dev/provider/animation_provider.dart';
import 'package:loan_calc_dev/ui/helper_widgets/home_page/home_page_helper_widgets.dart';
import 'package:loan_calc_dev/ui/helper_widgets/rounded_appbar.dart';
import 'package:loan_calc_dev/ui/pages/home_page/main_widgets/home_page_widgets.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationProvider animation;
  @override
  void initState() {
    super.initState();
    animation = Provider.of<AnimationProvider>(context, listen: false);
    animation.monthAnimationController = AnimationController(
      vsync: this,
      duration: AnimationProvider.expandedDuration,
    );
    animation.finalAnimationController = AnimationController(
      vsync: this,
      duration: AnimationProvider.expandedDuration,
    );
    animation.monthlyAnimation = CurvedAnimation(
      parent: animation.monthAnimationController,
      curve: Curves.fastOutSlowIn,
    );
    animation.finalAnimation = CurvedAnimation(
      parent: animation.finalAnimationController,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Provider.of<ShowDialogs>(context, listen: false).context = context;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          children: <Widget>[
            Center(
              child: Scroller.column(
                padding: EdgeInsets.only(
                  top: 56 + MediaQuery.of(context).padding.top,
                ),
                children: <Widget>[
                  MyCard(
                    child: Input(),
                  ),
                  RaisedButton(
                    onPressed: () =>
                        Provider.of<Calculation>(context, listen: false)
                            .incrementCounter(),
                    elevation: 4.0,
                    color: theme.primaryColor,
                    shape: const StadiumBorder(
                      side: BorderSide(
                        color: Colors.black38,
                      ),
                    ),
                    child: const Text(
                      'CALCULATE',
                      textScaleFactor: 1,
                      style: TextStyle(
                        fontSize: 23.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizeScaleTransition(
                    animation: animation.monthlyAnimation,
                    child: MyCard(
                      child: MonthlyPaymentResult(),
                    ),
                  ),
                  SizeScaleTransition(
                    animation: animation.finalAnimation,
                    child: MyCard(
                      child: FinalPayment(),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              height: 56 + MediaQuery.of(context).padding.top,
              child: RoundedAppBar(
                leading: FadeOutButton(),
                child: Text(
                  'LoanCalc',
                  textScaleFactor: 1,
                  style: theme.textTheme.headline6.copyWith(
                    fontSize: 40,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                trailing: SettingsButton(),
              ),
            ),
          ],
        ),
        drawer: HistoryDrawer(),
      ),
    );
  }
}
