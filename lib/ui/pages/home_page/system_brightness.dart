import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loan_calc_dev/provider/theme_provider.dart';
import 'package:loan_calc_dev/ui/themes/themes.dart';
import 'package:provider/provider.dart';

class SystemBrightness extends StatelessWidget {
  const SystemBrightness({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDeviceLight = themeProvider.getTheme == CalcThemes.lightTheme;
    final isPlatformLight = MediaQuery.of(context).platformBrightness == Brightness.light;
    final isAllLight = isDeviceLight && isPlatformLight;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor:
          isAllLight ? Colors.transparent : Colors.grey[850],
      systemNavigationBarIconBrightness:
          isAllLight ? Brightness.dark : Brightness.light,
      statusBarIconBrightness: isAllLight ? Brightness.dark : Brightness.light,
    ));
    return child;
  }
}