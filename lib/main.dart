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
  WidgetsFlutterBinding.ensureInitialized();
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
  const MyApp({Key? key, required this.isDark}) : super(key: key);

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(
            isDark ? CalcThemes.darkTheme : CalcThemes.lightTheme,
          ),
        ),
        Provider<AnimationProvider>(
          create: (_) => AnimationProvider(),
          dispose: (_, animation) {
            animation.dispose();
          },
        ),
        Provider<ShowDialogs>(
          create: (_) => ShowDialogs(),
        ),
        Provider<TextController>(
          create: (_) => TextController(),
          dispose: (_, controller) {
            controller.dispose();
          },
        ),
        ChangeNotifierProvider(
          create: (context) => Calculation(
            animationProvider: context.read<AnimationProvider>(),
            textController: context.read<TextController>(),
            showDialogs: context.read<ShowDialogs>(),
          )..inputTrackerStorage.loadIptList()..precisionStorage.loadPrecision(),
        ),
        // ChangeNotifierProxyProvider3<ShowDialogs, TextController,
        //     AnimationProvider, Calculation>(
        //   create: (_) => Calculation()
        //     ..inputTrackerStorage.loadIptList()
        //     ..precisionStorage.loadPrecision(),
        //   update: (
        //     _,
        //     showDialogs,
        //     textController,
        //     animationProvider,
        //     calculation,
        //   ) =>
        //       calculation!
        //         ..animationProvider = animationProvider
        //         ..textController = textController
        //         ..showDialogs = showDialogs,
        // )
      ],
      child: ThemeApp(),
    );
  }
}

class ThemeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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
