import 'package:loan_calc_dev/ui/route_generator/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBoolStorage {
  ThemeBoolStorage(this.preferences);

  final SharedPreferences preferences;

  bool _isDark = false;

  bool get isDark => _isDark;

  void loadThemeBool() {
    try {
      final isDark = preferences.getBool(SC.themePrefsKey);
      if (isDark != null) {
        _isDark = isDark;
      }
    } catch (_) {}
  }

  Future<void> setThemeBool(bool val) async {
    try {
      await preferences.setBool(SC.themePrefsKey, val);
      _isDark = val;
    } catch (_) {}
  }
}
