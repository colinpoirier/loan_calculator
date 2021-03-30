import 'package:flutter/material.dart';
import 'package:loan_calc_dev/storage/precision/precision_notifier.dart';
import 'package:loan_calc_dev/storage/theme_bool/theme_bool_notifier.dart';
import 'package:loan_calc_dev/ui/helper_widgets/home_page/home_page_helper_widgets.dart';
import 'package:loan_calc_dev/ui/themes/themes.dart';
import 'package:provider/provider.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({Key? key}) : super(key: key);

  static const values = <int>[0, 1, 2, 3, 4];

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeBoolNotifier>(context);
    final isDark = themeNotifier.theme == CalcThemes.darkTheme;
    final isPlatformLight = MediaQuery.platformBrightnessOf(context) == Brightness.light;
    final precisionNotifier = context.watch<PrecisionNotifier>();
    return Container(
      height: 200,
      child: Column(
        children: <Widget>[
          Expanded(
            child: MyCard(
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
          ),
          Expanded(
            child: MyCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    '.'.padRight(precisionNotifier.precision + 1, 'X'),
                    textScaleFactor: 1.0,
                    style: TextStyle(fontSize: 23),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: precisionNotifier.precision,
                      onChanged: (val) => precisionNotifier.updatePrecision(val!),
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
          ),
          Expanded(
            child: MyCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.brightness_5,
                      size: 30,
                    ),
                  ),
                  Switch(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: Colors.white,
                    inactiveThumbColor: Colors.black,
                    value: isPlatformLight ? isDark : true,
                    onChanged: (val) {
                      if (isPlatformLight) {
                        themeNotifier.setThemeBool(val);
                      }
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.brightness_3,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
