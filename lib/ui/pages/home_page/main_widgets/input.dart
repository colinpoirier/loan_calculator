import 'package:flutter/material.dart';
import 'package:loan_calc_dev/ui/helper_widgets/home_page/home_page_helper_widgets.dart';

class Input extends StatelessWidget {
  const Input({
    Key key,
    @required this.changeTime,
    @required this.timeChange,
    @required this.amountController,
    @required this.percentController,
    @required this.monthController,
    @required this.formKey
  }) : super(key: key);

  final bool changeTime;
  final TextEditingController amountController;
  final TextEditingController percentController;
  final TextEditingController monthController;
  final GlobalKey formKey;
  final ValueChanged<String> timeChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: const BoxConstraints(
        maxWidth: 550.0,
      ),
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
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
                  validator: (val) {
                    if (val.isNotEmpty) {
                      double amount = double.tryParse(val);
                      if (amount == null) {
                        return 'Please enter a number';
                      } else if (amount > 100000000) {
                        return 'Exceeds 100000000';
                      } else if (amount < 0.01) {
                        return 'Must be at least 0.01';
                      }
                    }
                  },
                  controller: amountController,
                ),
                InputPill(
                  maxWidth: constraints.maxWidth,
                  leadingText: "Interest",
                  hintText: 'Percent',
                  validator: (val) {
                    if (val.isNotEmpty) {
                      double percent = double.tryParse(val);
                      if (percent == null) {
                        return 'Please enter a number';
                      } else if (percent > 100) {
                        return 'Exceeds 100.0';
                      } else if (percent < 0.01) {
                        return 'Must be at least 0.01';
                      }
                    }
                  },
                  controller: percentController,
                ),
                InputPill(
                  maxWidth: constraints.maxWidth,
                  toDisplay: true,
                  leadingText: "Length",
                  hintText: changeTime ? 'Years' : 'Months',
                  validator: (val) {
                    if (val.isNotEmpty) {
                      double months = double.tryParse(val);
                      if (months == null) {
                        return 'Please enter a number';
                      } else if (changeTime) {
                        if (months > 50){
                          return 'Exceeds 50';
                        } else if (months < (1.0/12.0)){
                          return 'Must be at least 0.08333...';
                        } else if(months * 12 - (months * 12).toInt() != 0){
                          return 'Not a whole Month';
                        }
                      } else if (months > 600) {
                        return 'Exceeds 600';
                      } else if (months < 1) {
                        return 'Must be at least 1';                  
                      } else if ((months - months.toInt()) != 0) {
                        return 'Not a whole Month';
                      }
                    }
                  },
                  controller: monthController,
                  timeChange: timeChange,
                  timeChanged: changeTime,
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
