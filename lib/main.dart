import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loan_calc_dev/provider/theme_provider.dart';
import 'package:loan_calc_dev/ui/route_generator/route_generator.dart';
import 'package:loan_calc_dev/ui/route_generator/string_constants.dart';
import 'package:loan_calc_dev/ui/themes/themes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  final isDark = preferences.getBool(SC.themePrefsKey) ?? false;
  runApp(MyApp(
    isDark: isDark,
  ));
}

class MyApp extends StatelessWidget {

  const MyApp({Key key, this.isDark}) : super(key: key);

  final bool isDark;  

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(
      builder: (_) =>
          ThemeProvider(isDark ? CalcThemes.darkTheme : CalcThemes.lightTheme),
      child: ThemeApp(),
    );
  }
}

class ThemeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    bool themeToggle = theme.getTheme == CalcThemes.lightTheme;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor:
          themeToggle ? Colors.transparent : Colors.grey[850],
      systemNavigationBarIconBrightness:
          themeToggle ? Brightness.dark : Brightness.light,
      statusBarIconBrightness: themeToggle ? Brightness.dark : Brightness.light,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LoanCalc',
      theme: theme.getTheme,
      initialRoute: SC.homePage,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
