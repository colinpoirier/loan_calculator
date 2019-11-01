import 'package:flutter/material.dart';

class TextController{
  TextEditingController amount = TextEditingController();
  TextEditingController percent = TextEditingController();
  TextEditingController month = TextEditingController();

  void dispose(){
    amount?.dispose();
    percent?.dispose();
    month?.dispose();
  }
}