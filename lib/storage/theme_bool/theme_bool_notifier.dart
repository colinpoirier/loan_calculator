import 'package:flutter/material.dart';
import 'package:loan_calc_dev/storage/theme_bool/theme_bool_storage.dart';
import 'package:loan_calc_dev/ui/themes/themes.dart';

class ThemeBoolNotifier extends ChangeNotifier {

  ThemeBoolNotifier(this.themeBoolStorage);

  final ThemeBoolStorage themeBoolStorage;

  ThemeData get theme => themeBoolStorage.isDark ? CalcThemes.darkTheme : CalcThemes.lightTheme;

  void setThemeBool(bool val) async {
    await themeBoolStorage.setThemeBool(val);
    notifyListeners();
  }
}