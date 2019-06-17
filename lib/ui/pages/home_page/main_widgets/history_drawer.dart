import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loan_calc_dev/models/data_classes.dart';
import 'package:loan_calc_dev/ui/helper_widgets/home_page/condenser_widgets.dart';
import 'package:loan_calc_dev/ui/helper_widgets/my_card.dart';

class HistoryDrawer extends StatelessWidget {
  const HistoryDrawer({
    Key key,
    @required this.iptList,
    @required this.amountController,
    @required this.percentController,
    @required this.monthController,
    @required this.changeTime,
    @required this.setState,
  }) : super(key: key);

  final List<InputTracker> iptList;
  final TextEditingController amountController;
  final TextEditingController percentController;
  final TextEditingController monthController;
  final VoidCallback setState;
  final bool changeTime;

  void showDeleteConfirm(InputTracker input, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
          title: const Text('Delete?'),
          children: <Widget>[
            FlatButton(
              child: const Text('Confirm'),
              onPressed: () {
                iptList.remove(input);
                setState();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Drawer(
      elevation: 0,
      child: Column(
        children: <Widget>[
          MyCard(
            margin: EdgeInsets.fromLTRB(10, topPadding, 10, 10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Loan Calculation History',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.title.copyWith(
                  fontSize: 35,
                  fontWeight: FontWeight.normal
                )
              ),
            ),
          ),
          ExpandedListView(
            itemCount: iptList.length,
            itemBuilder: (context, index) {
              final input = iptList[index];
              return MyCard(
                child: PaddedInkWellColumn(
                  onLongPress: () => showDeleteConfirm(input, context),
                  onTap: () {
                    amountController.text = '${input.amount}';
                    percentController.text = '${input.percent * 1200}';
                    monthController.text =
                        changeTime ? '${input.month / 12}' : '${input.month}';
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
          )
        ],
      ),
    );
  }
}
