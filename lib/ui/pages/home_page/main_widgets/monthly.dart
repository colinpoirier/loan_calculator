import 'package:flutter/material.dart';
import 'package:loan_calc_dev/calculation/utils.dart';
import 'package:loan_calc_dev/convience_classes/animation_provider.dart';
import 'package:loan_calc_dev/state_management/rounding_notifier/rounding_notifier.dart';
import 'package:loan_calc_dev/ui/helper_widgets/home_page/home_page_helper_widgets.dart';
import 'package:provider/provider.dart';

class MonthlyPaymentResult extends StatelessWidget {
  const MonthlyPaymentResult({
    Key? key,
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
              return Consumer<RoundingNotifier>(
                builder: (_, roundingNotifier, __) {
                  final color = Theme.of(_).textTheme.bodyText1!.color!;
                  final payment = roundingNotifier.state.monthlyPayment();
                  return ScaleSwitcher(
                    duration: Animations.expandedDuration,
                    child: Container(
                      alignment: Alignment.center,
                      key: ValueKey(payment),
                      height: 47,
                      child: Text(
                        payment,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          color: roundingNotifier.state.isEditing ? color.withOpacity(0.5) : color,
                          fontSize: getFontSize(
                            40.0,
                            null,
                            constraints.maxWidth,
                            payment,
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
                      Consumer<RoundingNotifier>(
                        builder: (_, rounding, __) {
                          void Function(bool?)? onChanged;
                          if (!rounding.state.isEditing) {
                            // onChanged = rounding.roundUpChange;
                          }
                          return Checkbox(
                            value: rounding.state.roundUp,
                            onChanged: onChanged,
                          );
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    width: (constraints.maxWidth - 210).clamp(0.0, 65.0),
                  ),
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
                      Consumer<RoundingNotifier>(
                        builder: (_, rounding, __) {
                          void Function(bool?)? onChanged;
                          if (!rounding.state.isEditing) {
                            // onChanged = rounding.roundDownChange;
                          }
                          return Checkbox(
                            value: rounding.state.roundDown,
                            onChanged: onChanged,
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
