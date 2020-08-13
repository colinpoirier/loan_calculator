import 'package:flutter/material.dart';
import 'package:loan_calc_dev/calculation/calculation.dart';
import 'package:loan_calc_dev/text_controller/text_controller.dart';
import 'package:loan_calc_dev/ui/helper_widgets/home_page/home_page_helper_widgets.dart';
import 'package:loan_calc_dev/validators/validators.dart';
import 'package:provider/provider.dart';

class Input extends StatelessWidget {
  const Input({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textController = Provider.of<TextController>(context);
    final calculation = Provider.of<Calculation>(context);
    final isChangeTime = calculation.isChangeTime;
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: const BoxConstraints(
        maxWidth: 550.0,
      ),
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: calculation.formKey,
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
                  validator: Validator.amount,
                  controller: textController.amount,
                ),
                InputPill(
                  maxWidth: constraints.maxWidth,
                  leadingText: "Interest",
                  hintText: 'Percent',
                  validator: Validator.interest,
                  controller: textController.percent,
                ),
                InputPill(
                  maxWidth: constraints.maxWidth,
                  toDisplay: true,
                  leadingText: "Length",
                  hintText: isChangeTime ? 'Years' : 'Months',
                  validator: (val) => Validator.length(val, isChangeTime),
                  controller: textController.month,
                  timeChange: calculation.timechange,
                  timeChanged: isChangeTime,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
