import 'package:flutter/material.dart';
import 'package:loan_calc_dev/state_management/input_notifier/input_notifier.dart';
import 'package:loan_calc_dev/state_management/rounding_notifier/rounding_notifier.dart';
import 'package:provider/provider.dart';

class CalculateButton extends StatelessWidget {
  const CalculateButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canSubmit = context.select<InputNotifier, bool>((value) => value.state.canSubmit);
    void Function()? onPressed;
    if (canSubmit) {
      onPressed = () {
        final inputState = context.read<InputNotifier>().state;
        context.read<RoundingNotifier>().calculate(inputState);
      };
    }
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 4.0,
        primary: theme.primaryColor,
        shape: const StadiumBorder(
          side: BorderSide(
            color: Colors.black38,
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        'CALCULATE',
        textScaleFactor: 1,
        style: theme.textTheme.bodyText1!.copyWith(
          fontSize: 23.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
