import 'package:flutter/material.dart';
import 'package:loan_calc_dev/calculation/utils.dart';
import 'package:loan_calc_dev/models/data_classes.dart';
import 'package:loan_calc_dev/storage/input_tracker/input_tracker_notifier.dart';

class ShowDialogs {
  static late BuildContext context;

  static void unFocus() => FocusScope.of(context).unfocus();

  static void ooops(
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
          TextButton(
            child: Text(
              'Go back',
              style: TextStyle(color: Theme.of(context).textTheme.bodyText2!.color),
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  static void showDeleteConfirm(
    InputTracker input,
    BuildContext context,
    InputTrackerNotifier inputTrackerNotifier,
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
          TextButton(
            child: const Text('Confirm'),
            onPressed: () async {
              await inputTrackerNotifier.removeFromIpt(input);
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
