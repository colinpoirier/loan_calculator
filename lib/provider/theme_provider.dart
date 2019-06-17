import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier{
  ThemeData _themeData;

  ThemeProvider(this._themeData);

  ThemeData get getTheme => _themeData;
  setTheme(ThemeData theme){
    _themeData = theme;

    notifyListeners();
  }
}