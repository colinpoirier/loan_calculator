import 'package:flutter/material.dart';
import 'package:loan_calc_dev/state_management/input_notifier/input_notifier.dart';
import 'package:loan_calc_dev/ui/helper_widgets/home_page/home_page_helper_widgets.dart';
import 'package:provider/provider.dart';

class Input extends StatelessWidget {
  const Input({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputNotifier = Provider.of<InputNotifier>(context);
    final inputState = inputNotifier.state;
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: const BoxConstraints(
        maxWidth: 550.0,
      ),
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InputPill(
                maxWidth: constraints.maxWidth,
                leadingText: "Loan Amount",
                hintText: 'Currency',
                controller: inputNotifier.amount,
                errorText: inputState.amountError,
              ),
              InputPill(
                maxWidth: constraints.maxWidth,
                leadingText: "Interest",
                hintText: 'Percent',
                controller: inputNotifier.percent,
                errorText: inputState.percentError,
              ),
              InputPill(
                maxWidth: constraints.maxWidth,
                toDisplay: true,
                leadingText: "Length",
                hintText: inputState.changeTime ? 'Years' : 'Months',
                controller: inputNotifier.length,
                timeChange: inputNotifier.changeTimechange,
                timeChanged: inputState.changeTime,
                errorText: inputState.lengthError,
              ),
            ],
          );
        },
      ),
    );
  }
}
