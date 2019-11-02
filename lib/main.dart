import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loan_calc_dev/calculation/calculation.dart';
import 'package:loan_calc_dev/dialogs/dialogs.dart';
import 'package:loan_calc_dev/provider/animation_provider.dart';
import 'package:loan_calc_dev/provider/theme_provider.dart';
import 'package:loan_calc_dev/text_controller/text_controller.dart';
import 'package:loan_calc_dev/ui/route_generator/route_generator.dart';
import 'package:loan_calc_dev/ui/route_generator/string_constants.dart';
import 'package:loan_calc_dev/ui/themes/themes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:device_preview/device_preview.dart';

Future main() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  final isDark = preferences.getBool(SC.themePrefsKey) ?? false;
  // runApp(DevicePreview(builder:(context)=>MyApp(
  //       isDark: isDark,
  //     )));
  runApp(MyApp(
        isDark: isDark,
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key, this.isDark}) : super(key: key);

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          builder: (_) => ThemeProvider(
            isDark ? CalcThemes.darkTheme : CalcThemes.lightTheme,
          ),
        ),
        Provider<AnimationProvider>(
          builder: (_) => AnimationProvider(),
          dispose: (_, animation) {
            animation.dispose();
          },
        ),
        Provider<ShowDialogs>(
          builder: (_) => ShowDialogs(),
        ),
        Provider<TextController>(
          builder: (_) => TextController(),
          dispose: (_, controller) {
            controller.dispose();
          },
        ),
        ChangeNotifierProxyProvider3<ShowDialogs, TextController,
            AnimationProvider, Calculation>(
          initialBuilder: (_) => Calculation()
            ..inputTrackerStorage.loadIptList()
            ..precisionStorage.loadPrecision(),
          builder: (
            _,
            showDialogs,
            textController,
            animationProvider,
            calculation,
          ) =>
              calculation
                ..animationProvider = animationProvider
                ..textController = textController
                ..showDialogs = showDialogs,
        )
      ],
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
      // builder: DevicePreview.appBuilder,
      // locale: DevicePreview.of(context).locale,
      debugShowCheckedModeBanner: false,
      title: 'LoanCalc',
      theme: theme.getTheme,
      darkTheme: CalcThemes.darkTheme,
      initialRoute: SC.homePage,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
