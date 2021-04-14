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

  String toString() =>
      'paidInt: $paidInt, payment: $payment, paidPrinc: $paidPrinc, month: $month, totPrinc: $totPrinc, totInt: $totInt, isExpanded: $expanded, offset: $offset';
}

class InputTracker {
  final double month;
  final double amount;
  final double percent;
  final String monthsString;
  final String amountString;
  final String percentString;

  InputTracker({
    required this.month,
    required this.amount,
    required this.percent,
    required this.monthsString,
    required this.amountString,
    required this.percentString,
  });

  Map<String, dynamic> toJson() => {
        'month': month,
        'amount': amount,
        'percent': percent,
        'monthsString': monthsString,
        'amountString': amountString,
        'percentString': percentString,
      };

  static InputTracker fromJson(Map<String, dynamic> json) => InputTracker(
        amount: double.parse(json['amount']),
        percent: double.parse(json['percent']),
        month: double.parse(json['month']),
        amountString: json['amountString']??'',
        percentString: json['percentString']??'',
        monthsString: json['monthString']??'',
      );

  bool operator ==(other) =>
      other is InputTracker && other.amount == amount && other.month == month && other.percent == percent;

  int get hashCode => hashList([amount, month, percent]);

  String toString() => '''month: $month\n
      amount: $amount\n
      percent: $percent\n''';
}
