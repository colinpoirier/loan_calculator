import 'package:flutter/material.dart';
import 'package:loan_calc_dev/models/data_classes.dart';
import 'package:loan_calc_dev/storage/input_tracker/input_tracker_storage.dart';

class InputTrackerNotifier extends ChangeNotifier {
  InputTrackerNotifier(this.inputTrackerStorage);

  final InputTrackerStorage inputTrackerStorage;

  List<InputTracker> get iptList => inputTrackerStorage.iptList;

  Future<void> addToIpt(InputTracker ipt) async {
    await inputTrackerStorage.handleAddToInputTracker(ipt);
    notifyListeners();
  }

  Future<void> removeFromIpt(InputTracker ipt) async {
    await inputTrackerStorage.handleRemoveFromInputTracker(ipt);
    notifyListeners();
  }

}