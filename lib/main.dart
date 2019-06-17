import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loan_calc_dev/provider/theme_provider.dart';
import 'package:loan_calc_dev/ui/route_generator/route_generator.dart';
import 'package:loan_calc_dev/ui/route_generator/string_constants.dart';
import 'package:loan_calc_dev/ui/themes/themes.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(
      builder: (_) => ThemeProvider(CalcThemes.lightTheme),
      child: ThemeApp()
    );
  }
}

class ThemeApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    bool themeToggle = theme.getTheme == CalcThemes.lightTheme;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: themeToggle ? Colors.transparent : Colors.grey[850],
      systemNavigationBarIconBrightness: themeToggle ? Brightness.dark : Brightness.light,
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
