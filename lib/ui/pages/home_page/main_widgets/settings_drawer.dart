import 'package:flutter/material.dart';
import 'package:loan_calc_dev/calculation/calculation.dart';
import 'package:loan_calc_dev/provider/theme_provider.dart';
import 'package:loan_calc_dev/ui/helper_widgets/home_page/home_page_helper_widgets.dart';
import 'package:loan_calc_dev/ui/route_generator/string_constants.dart';
import 'package:loan_calc_dev/ui/themes/themes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({Key key}) : super(key: key);

  static const values = <int>[0, 1, 2, 3, 4];

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProvider>(context);
    final isDark = themeChange.getTheme == CalcThemes.darkTheme;
    final isPlatformLight =
        MediaQuery.platformBrightnessOf(context) == Brightness.light;
    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          MyCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(
                    Icons.settings,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          MyCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Text(
                  '.XX',
                  textScaleFactor: 1.0,
                  style: const TextStyle(fontSize: 23),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: Provider.of<Calculation>(context).precision,
                    onChanged: (val) =>
                        Provider.of<Calculation>(context).precision = val,
                    items: values
                        .map(
                          (index) => DropdownMenuItem(
                            child: Text(
                              '$index',
                              textScaleFactor: 1.0,
                              style: const TextStyle(fontSize: 23),
                            ),
                            value: index,
                          ),
                        )
                        .toList(),
                  ),
                )
              ],
            ),
          ),
          MyCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(
                    Icons.brightness_5,
                    size: 30,
                  ),
                ),
                Switch(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  activeColor: Colors.white,
                  inactiveThumbColor: Colors.black,
                  value: isPlatformLight ? isDark : true,
                  onChanged: (_) async {
                    if (isPlatformLight) {
                      await SharedPreferences.getInstance()
                        ..setBool(SC.themePrefsKey, !isDark);
                      themeChange.setTheme(
                        isDark ? CalcThemes.lightTheme : CalcThemes.darkTheme,
                      );
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(
                    Icons.brightness_3,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
