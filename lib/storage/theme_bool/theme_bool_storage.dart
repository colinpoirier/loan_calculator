import 'package:loan_calc_dev/ui/route_generator/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBoolStorage {
  ThemeBoolStorage(this.preferences);

  final SharedPreferences preferences;

  bool _isDark = false;

  bool get isDark => _isDark;

  void loadThemeBool() {
    final isDark = preferences.getBool(SC.themePrefsKey);
    if (isDark != null) {
      _isDark = isDark;
    }
  }

  Future<void> setThemeBool(bool val) async {
    await preferences.setBool(SC.themePrefsKey, val);   
    _isDark = val; 
  }
}
