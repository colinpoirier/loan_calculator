import 'package:flutter/material.dart';
import 'package:loan_calc_dev/calculation/calculation.dart';
import 'package:loan_calc_dev/dialogs/dialogs.dart';
import 'package:loan_calc_dev/ui/helper_widgets/home_page/condenser_widgets.dart';
import 'package:loan_calc_dev/ui/helper_widgets/my_card.dart';
import 'package:provider/provider.dart';

class HistoryDrawer extends StatelessWidget {
  const HistoryDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final theme = Theme.of(context);
    final calculation = Provider.of<Calculation>(context);
    final showDialogs = Provider.of<ShowDialogs>(context,listen: false);
    return Drawer(
      elevation: 0,
      child: ListViewStack(
        padding: EdgeInsets.only(top: 56 + topPadding),
        itemCount: calculation.iptList.length,
        itemBuilder: (context, index) {
          final input = calculation.iptList[index];
          return MyCard(
            child: PaddedInkWellColumn(
              onLongPress: () => showDialogs.showDeleteConfirm(input, context, calculation),
              onTap: () {
                calculation.assignTextControllers(input);
                Navigator.of(context).pop();
              },
              children: <Widget>[
                Text('Amount: ${input.amount}', textScaleFactor: 1.0,),
                Text('Percent: ${input.percent * 1200}', textScaleFactor: 1.0,),
                Text('Months: ${input.month}', textScaleFactor: 1.0,)
              ],
            ),
          );
        },
        top: Positioned(
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
      ),
    );
  }
}
