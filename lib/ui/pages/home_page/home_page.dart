import 'package:flutter/material.dart';
import 'package:loan_calc_dev/dialogs/dialogs.dart';
import 'package:loan_calc_dev/convience_classes/saved_index.dart';
import 'package:loan_calc_dev/convience_classes/animation_provider.dart';
import 'package:loan_calc_dev/state_management/final_notifier/final_notifier.dart';
import 'package:loan_calc_dev/state_management/input_notifier/input_notifier.dart';
import 'package:loan_calc_dev/state_management/rounding_notifier/rounding_notifier.dart';
import 'package:loan_calc_dev/storage/input_tracker/input_tracker_notifier.dart';
import 'package:loan_calc_dev/storage/precision/precision_notifier.dart';
import 'package:loan_calc_dev/ui/helper_widgets/home_page/home_page_helper_widgets.dart';
import 'package:loan_calc_dev/ui/helper_widgets/rounded_appbar.dart';
import 'package:loan_calc_dev/ui/pages/home_page/main_widgets/home_page_widgets.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late Animations animations;
  
  @override
  void initState() {
    super.initState();
    ShowDialogs.context = context;
    animations = Animations(vsync: this);
  }

  @override
  void dispose() {
    animations.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => InputNotifier(
            precisionNotifier: context.read<PrecisionNotifier>(),
        ),),
        ChangeNotifierProvider(
          create: (context) => RoundingNotifier(
            inputNotifier: context.read<InputNotifier>(),
            precisionNotifier: context.read<PrecisionNotifier>(),
            inputTrackerNotifier: context.read<InputTrackerNotifier>(),
            monthlyPaymentController: animations.monthAnimationController,
            savedIndex: context.read<SavedIndex>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => FinalNotifier(
            roundingNotifier: context.read<RoundingNotifier>(),
            precisionNotifier: context.read<PrecisionNotifier>(),
            finalPaymentController: animations.finalAnimationController,
          ),
        ),
      ],
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: RoundedAppBar(
            leading: const HistoryButton(),
            child: Text(
              'LoanCalc',
              textScaleFactor: 1,
              style: theme.textTheme.headline6!.copyWith(
                fontSize: 40,
                fontWeight: FontWeight.normal,
              ),
            ),
            trailing: const SettingsButton(),
          ),
          body: Center(
            child: Scroller.column(
              padding: EdgeInsets.only(
                top: 56 + MediaQuery.of(context).padding.top,
              ),
              children: <Widget>[
                const MyCard(
                  child: Input(),
                ),
                const CalculateButton(),
                SizeScaleTransition(
                  animation: animations.monthlyAnimation,
                  child: const MyCard(
                    child: MonthlyPaymentResult(),
                  ),
                ),
                SizeScaleTransition(
                  animation: animations.finalAnimation,
                  child: const MyCard(
                    child: FinalPayment(),
                  ),
                ),
              ],
            ),
          ),
          drawer: const HistoryDrawer(),
        ),
      ),
    );
  }
}
