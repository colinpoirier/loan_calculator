import 'package:flutter/material.dart';
import 'package:loan_calc_dev/calculation/calculation.dart';
import 'package:loan_calc_dev/dialogs/dialogs.dart';
// import 'package:loan_calc_dev/models/data_classes.dart';
// import 'package:loan_calc_dev/provider/theme_provider.dart';
import 'package:loan_calc_dev/text_controller/text_controller.dart';
import 'package:loan_calc_dev/ui/helper_widgets/home_page/condenser_widgets.dart';
import 'package:loan_calc_dev/ui/helper_widgets/my_card.dart';
// import 'package:loan_calc_dev/ui/helper_widgets/positioned_decoration.dart';
// import 'package:loan_calc_dev/ui/route_generator/string_constants.dart';
// import 'package:loan_calc_dev/ui/themes/themes.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class HistoryDrawer extends StatelessWidget {
  const HistoryDrawer({
    Key key,
    // @required this.iptList,
    // @required this.amountController,
    // @required this.percentController,
    // @required this.monthController,
    // @required this.changeTime,
    // @required this.setState,
  }) : super(key: key);

  // final List<InputTracker> iptList;
  // final TextEditingController amountController;
  // final TextEditingController percentController;
  // final TextEditingController monthController;
  // final VoidCallback setState;
  // final bool changeTime;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final theme = Theme.of(context);
    // final themeChange = Provider.of<ThemeProvider>(context);
    // final isDark = themeChange.getTheme == CalcThemes.darkTheme;
    final calculation = Provider.of<Calculation>(context);
    final textController = Provider.of<TextController>(context, listen: false);
    final showDialogs = Provider.of<ShowDialogs>(context,listen: false);
    return Drawer(
      elevation: 0,
      child: Column(
        children: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          //   child: Material(
          //     elevation: 4,
          //     color: theme.primaryColor,
          //     borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
          //     child: Container(
          //       width: double.infinity,
          //       padding: EdgeInsets.only(top: topPadding, bottom: 10),
          //       child: Icon(Icons.history),
          //     ),
          //   ),
          // ),
          // MyCard(
          //   margin: EdgeInsets.fromLTRB(10, topPadding, 10, 10),
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Text(
          //       'Loan Calculation History',
          //       textAlign: TextAlign.center,
          //       style: theme.textTheme.title
          //           .copyWith(fontSize: 35, fontWeight: FontWeight.normal),
          //     ),
          //   ),
          // ),
          ExpandedListViewStack(
            padding: EdgeInsets.only(top: 56 + topPadding),
            itemCount: calculation.iptList.length,
            itemBuilder: (context, index) {
              final input = calculation.iptList[index];
              return MyCard(
                child: PaddedInkWellColumn(
                  onLongPress: () => showDialogs.showDeleteConfirm(input, context, calculation),
                  onTap: () {
                    textController.amount.text = '${input.amount}';
                    textController.percent.text = '${input.percent * 1200}';
                    textController.month.text =
                        calculation.changeTime ? '${input.month / 12}' : '${input.month}';
                    Navigator.of(context).pop();
                  },
                  children: <Widget>[
                    Text('Amount: ${input.amount}'),
                    Text('Percent: ${input.percent * 1200}'),
                    Text('Months: ${input.month}')
                  ],
                ),
              );
            },
            // positionedDecoration: PositionedDecoration(
            //   color: theme.scaffoldBackgroundColor,
            // ),
            positionedDecoration: Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 56 + topPadding,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Material(
                  elevation: 4,
                  color: theme.primaryColor,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(30)),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.only(bottom: 5),
                    child: const Icon(
                      Icons.history,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            // bottomDecoration: PositionedDecorationBottom(
            //   color: theme.scaffoldBackgroundColor,
            // ),
          ),
          // MyCard(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: <Widget>[
          //       const Icon(Icons.brightness_5),
          //       Transform.scale(
          //         scale: 0.8,
          //         child: Switch.adaptive(
          //           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //           activeColor: Colors.white,
          //           inactiveThumbColor: Colors.black,
          //           value: isDark,
          //           onChanged: (_) async {
          //             await SharedPreferences.getInstance()
          //               ..setBool(SC.themePrefsKey, !isDark);
          //             themeChange.setTheme(isDark
          //                 ? CalcThemes.lightTheme
          //                 : CalcThemes.darkTheme);
          //           },
          //         ),
          //       ),
          //       const Icon(Icons.brightness_3),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
