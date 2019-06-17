import 'package:flutter/material.dart';

class MonthlyBreakDown {
  double payment;
  int month;
  double paidInt;
  double paidPrinc;
  double totPrinc;
  double totInt;

  MonthlyBreakDown({
    this.payment,
    this.month,
    this.paidInt,
    this.paidPrinc,
    this.totPrinc,
    this.totInt,
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

  Map toJson() => {
    'month': this.month,
    'amount': this.amount,
    'percent': this.percent
  };

  static InputTracker fromJson(Map json)=>InputTracker(
    amount: json['amount'],
    percent: json['percent'],
    month: json['month']);

  bool operator ==(other) =>
      other is InputTracker &&
      other.amount == this.amount &&
      other.month == this.month &&
      other.percent == this.percent;

  int get hashCode => hashList([this.amount, this.month, this.percent]);

  String toString() => '''month: $month\n
      amount: $amount\n
      percent: $percent\n''';
}
