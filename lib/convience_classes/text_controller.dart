import 'package:flutter/material.dart';

class TextController {
  final TextEditingController amount = TextEditingController();
  final TextEditingController percent = TextEditingController();
  final TextEditingController month = TextEditingController();

  void dispose() {
    amount.dispose();
    percent.dispose();
    month.dispose();
  }
}
