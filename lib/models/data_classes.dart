import 'package:flutter/material.dart';

class MonthlyBreakDown {
  final double payment;
  final int month;
  final double paidInt;
  final double paidPrinc;
  final double totPrinc;
  final double totInt;
  bool expanded;
  double offset;

  MonthlyBreakDown({
    required this.payment,
    required this.month,
    required this.paidInt,
    required this.paidPrinc,
    required this.totPrinc,
    required this.totInt,
    this.expanded = false,
    this.offset = 0,
  });

  String toString() => 'paidInt: $paidInt, payment: $payment, paidPrinc: $paidPrinc, month: $month, totPrinc: $totPrinc, totInt: $totInt, isExpanded: $expanded, offset: $offset';
}

class InputTracker {
  final double month;
  final double amount;
  final double percent;

  InputTracker({
    required this.month,
    required this.amount,
    required this.percent,
  });

  Map<String, double?> toJson() => {
        'month': month,
        'amount': amount,
        'percent': percent,
      };

  static InputTracker fromJson(Map<String, dynamic> json) => InputTracker(
        amount: json['amount'],
        percent: json['percent'],
        month: json['month'],
      );

  bool operator ==(other) =>
      other is InputTracker &&
      other.amount == amount &&
      other.month == month &&
      other.percent == percent;

  int get hashCode => hashList([amount, month, percent]);

  String toString() => '''month: $month\n
      amount: $amount\n
      percent: $percent\n''';
}
