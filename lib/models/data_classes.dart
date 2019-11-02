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
    this.payment,
    this.month,
    this.paidInt,
    this.paidPrinc,
    this.totPrinc,
    this.totInt,
    this.expanded = false,
    this.offset = 0,
  });

  String toString() => '''paidInt: $paidInt\n
      payment: $payment\n
      paidPrinc: $paidPrinc\n
      month: $month\n
      totPrinc: $totPrinc\n
      totInt: $totInt\n''';
}

class InputTracker {
  double month;
  double amount;
  double percent;

  InputTracker({
    this.month,
    this.amount,
    this.percent,
  });

  Map<String, double> toJson() => {
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
