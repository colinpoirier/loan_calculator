import 'package:flutter/material.dart';
import 'package:loan_calc_dev/ui/helper_widgets/home_page/home_page_helper_widgets.dart';

class MonthlyPaymentResult extends StatelessWidget {
  const MonthlyPaymentResult({
    Key key,
    @required this.resultWidth,
    @required this.resultHeight,
    @required this.expandedDuration,
    @required this.roundUp,
    @required this.roundDown,
    @required this.onCheckUp,
    @required this.onCheckDown,
    @required this.monthlyPayment,
  }) : super(key: key);

  final double resultWidth;
  final double resultHeight;
  final Duration expandedDuration;
  final bool roundUp;
  final bool roundDown;
  final String monthlyPayment;
  final ValueChanged<bool> onCheckUp;
  final ValueChanged<bool> onCheckDown;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      constraints: const BoxConstraints(
        maxWidth: 550,
      ),
      curve: Curves.fastOutSlowIn,
      width: resultWidth,
      height: resultHeight,
      duration: expandedDuration,
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 5.0),
      child: Scroller.column(
        children: <Widget>[
          const Text(
            'Monthly Payment',
            softWrap: false,
            style: TextStyle(
              fontSize: 22.0,
            ),
          ),
          ScaleSwitcher(
            duration: expandedDuration,
            child: Text(
              monthlyPayment,
              key: ValueKey(monthlyPayment),
              softWrap: false,
              style: const TextStyle(
                fontSize: 40.0,
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Scroller.row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: 100,
                    child: const Text(
                      'Round Up',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  Checkbox(
                    value: roundUp,
                    onChanged: onCheckUp,
                  )
                ],
              ),
              const SizedBox(width: 65.0),
              Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: 100,
                    child: const Text(
                      'Round Down',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  Checkbox(
                    value: roundDown,
                    onChanged: onCheckDown,
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
