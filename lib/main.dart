import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loan_calc_dev/convience_classes/saved_index.dart';
import 'package:loan_calc_dev/storage/input_tracker/input_tracker_storage.dart';
import 'package:loan_calc_dev/storage/input_tracker/input_tracker_notifier.dart';
import 'package:loan_calc_dev/storage/precision/precision_notifier.dart';
import 'package:loan_calc_dev/storage/precision/precision_storage.dart';
import 'package:loan_calc_dev/storage/theme_bool/theme_bool_notifier.dart';
import 'package:loan_calc_dev/storage/theme_bool/theme_bool_storage.dart';
import 'package:loan_calc_dev/ui/route_generator/route_generator.dart';
import 'package:loan_calc_dev/ui/route_generator/string_constants.dart';
import 'package:loan_calc_dev/ui/themes/themes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:device_preview/device_preview.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  // final isDark = preferences.getBool(SC.themePrefsKey) ?? false;
  // runApp(DevicePreview(builder:(context)=>MyApp(
  //       isDark: isDark,
  //     )));
  runApp(MyApp(
    // isDark: isDark,
    preferences: preferences,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.preferences}) : super(key: key);

  // final bool isDark;
  final SharedPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InputTrackerNotifier(InputTrackerStorage(preferences)..loadIptList())),
        ChangeNotifierProvider(create: (_) => PrecisionNotifier(PrecisionStorage(preferences)..loadPrecision())),
        ChangeNotifierProvider(create: (_) => ThemeBoolNotifier(ThemeBoolStorage(preferences)..loadThemeBool())),
        Provider(create: (_) => SavedIndex()),
        // ChangeNotifierProvider<ThemeProvider>(
        //   create: (_) => ThemeProvider(
        //     isDark ? CalcThemes.darkTheme : CalcThemes.lightTheme,
        //   ),
        // ),
        // Provider<AnimationProvider>(
        //   create: (_) => AnimationProvider(),
        //   dispose: (_, animation) {
        //     animation.dispose();
        //   },
        // ),
        // ChangeNotifierProvider(
        //   create: (context) => Calculation(
        //     preferences: preferences,
        //     animationProvider: context.read<AnimationProvider>(),
        //     textController: TextController(),
        //   )..inputTrackerStorage.loadIptList()..precisionStorage.loadPrecision(),
        // ),
      ],
      child: ThemeApp(),
    );
  }
}

class ThemeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeBoolNotifier>(context).theme;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      // builder: DevicePreview.appBuilder,
      // locale: DevicePreview.of(context).locale,
      debugShowCheckedModeBanner: false,
      title: 'LoanCalc',
      theme: theme,
      darkTheme: CalcThemes.darkTheme,
      initialRoute: SC.homePage,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
