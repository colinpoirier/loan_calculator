import 'package:flutter/material.dart';
import 'package:loan_calc_dev/calculation/calculation.dart';
import 'package:loan_calc_dev/calculation/utils.dart';
import 'package:loan_calc_dev/provider/animation_provider.dart';
import 'package:loan_calc_dev/ui/helper_widgets/home_page/home_page_helper_widgets.dart';
import 'package:provider/provider.dart';

class MonthlyPaymentResult extends StatelessWidget {
  const MonthlyPaymentResult({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 177,
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 5.0),
      child: Scroller.column(
        children: <Widget>[
          const Text(
            'Monthly Payment',
            textScaleFactor: 1.0,
            softWrap: false,
            style: TextStyle(
              fontSize: 22.0,
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Consumer<Calculation>(
                builder: (_, calculation, __) {
                  return ScaleSwitcher(
                    duration: AnimationProvider.expandedDuration,
                    child: Container(
                      alignment: Alignment.center,
                      key: ValueKey(calculation.monthlyPayment()),
                      height: 47,
                      child: Text(
                        calculation.monthlyPayment(),
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          fontSize: getFontSize(
                            40.0,
                            null,
                            constraints.maxWidth,
                            calculation.monthlyPayment(),
                            TextDirection.ltr,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(
            height: 10.0,
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Scroller.row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        width: 105,
                        child: const Text(
                          'Round Up',
                          textScaleFactor: 1.0,
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Consumer<Calculation>(
                        builder: (_, calculation, __) {
                          return Checkbox(
                            value: calculation.isRoundUp,
                            onChanged: calculation.onCheckUp,
                          );
                        },
                      )
                    ],
                  ),
                  SizedBox(
                      width: (constraints.maxWidth - 210).clamp(0.0, 65.0)),
                  Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        width: 105,
                        child: const Text(
                          'Round Down',
                          textScaleFactor: 1.0,
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Consumer<Calculation>(
                        builder: (_, calculation, __) {
                          return Checkbox(
                            value: calculation.isRoundDown,
                            onChanged: calculation.onCheckDown,
                          );
                        },
                      )
                    ],
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
