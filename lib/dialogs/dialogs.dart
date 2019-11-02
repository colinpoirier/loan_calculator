import 'package:flutter/material.dart';
import 'package:loan_calc_dev/calculation/calculation.dart';
import 'package:loan_calc_dev/calculation/utils.dart';
import 'package:loan_calc_dev/models/data_classes.dart';

class ShowDialogs {
  BuildContext context;

  void requestFocus() => FocusScope.of(context).requestFocus(FocusNode());

  void ooops(
    double counter,
    double interest,
    int precision,
  ) {
    final counterString =
        roundDown(counter, precision).toStringAsFixed(precision);
    final interestString = interest.toStringAsFixed(precision + 3);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Oops'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'Payment would be less than or equal\nto first month\'s interest.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Text('$counterString ≤ $interestString')
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Go back',
              style: TextStyle(color: Theme.of(context).textTheme.body1.color),
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  void showDeleteConfirm(
    InputTracker input,
    BuildContext context,
    Calculation calculation,
  ) {
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
            onPressed: () async {
              calculation.iptList.remove(input);
              await calculation.inputTrackerStorage.saveIptList();
              calculation.update();
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
