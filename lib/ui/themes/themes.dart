import 'package:flutter/material.dart';

class CalcThemes {
  static ThemeData _primaryTheme({
    required Brightness? brightness,
    required Color? primaryColor,
    required Color? scaffoldBackgroundColor,
    required Color? canvasColor,
    required Color? fillColor,
    required Color? toggleableActiveColor,
    required Color? selectionHandleColor,
    required TextTheme? textTheme,
  }) =>
      ThemeData(
        brightness: brightness,
        primaryColor: primaryColor,
        // accentColor: args[2],
        // colorSchemeSeed: args[2],
        // colorScheme: ColorScheme(secondary: args[2], background: args[0], brightness: args[3], error: Colors.red, onBackground: args[2], onError: Colors.black, onPrimary: Colors.black, onSecondary: Colors.black, onSurface: Colors.black, primary: args[2], surface: args[2]),
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        canvasColor: canvasColor,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: fillColor,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        ),
        toggleableActiveColor: toggleableActiveColor,
        textSelectionTheme: TextSelectionThemeData(selectionHandleColor: selectionHandleColor),
        textTheme: textTheme,
      );
  // static _primaryTheme(List args) => ThemeData(
  //   brightness: args[3],
  //   primaryColor: args[2],
  //   // accentColor: args[2],
  //   // colorSchemeSeed: args[2],
  //   // colorScheme: ColorScheme(secondary: args[2], background: args[0], brightness: args[3], error: Colors.red, onBackground: args[2], onError: Colors.black, onPrimary: Colors.black, onSecondary: Colors.black, onSurface: Colors.black, primary: args[2], surface: args[2]),
  //   scaffoldBackgroundColor: args[0],
  //   canvasColor: args[0],
  //   inputDecorationTheme: InputDecorationTheme(
  //     filled: true,
  //     fillColor: args[1],
  //     border: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(30.0),
  //     ),
  //     contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
  //   ),
  //   toggleableActiveColor: args[4],
  //   textSelectionTheme: TextSelectionThemeData(selectionHandleColor: args[5]),
  //   textTheme: args[6]

  // );

  static ThemeData lightTheme = _primaryTheme(
    brightness: Brightness.light,
    primaryColor: Colors.blue[100],
    scaffoldBackgroundColor: Colors.white,
    canvasColor: Colors.white,
    fillColor: Colors.white,
    toggleableActiveColor: Colors.black,
    selectionHandleColor: Colors.blue,
    textTheme: null,
  );

  static ThemeData darkTheme = _primaryTheme(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF002a62),
    scaffoldBackgroundColor: Colors.grey[850],
    canvasColor: Colors.grey[850],
    fillColor: Colors.grey[600],
    toggleableActiveColor: Colors.grey[600],
    selectionHandleColor: Colors.blue[100],
    textTheme: whiteTextTheme,
  );

  // static ThemeData lightTheme = _primaryTheme([
  //   Colors.white,
  //   Colors.white,
  //   Colors.blue[100],
  //   Brightness.light,
  //   Colors.black,
  //   Colors.blue,
  //   null
  // ]);

  // static ThemeData darkTheme = _primaryTheme([
  //   Colors.grey[850],
  //   Colors.grey[600],
  //   Color(0xFF002a62),
  //   Brightness.dark,
  //   Colors.grey[600],
  //   Colors.blue[100],
  //   whiteTextTheme,
  // ]);
  static const TextTheme whiteTextTheme = TextTheme(
    headline1: TextStyle(inherit: true, color: Colors.white70, decoration: TextDecoration.none),
    headline2: TextStyle(inherit: true, color: Colors.white70, decoration: TextDecoration.none),
    headline3: TextStyle(inherit: true, color: Colors.white70, decoration: TextDecoration.none),
    headline4: TextStyle(inherit: true, color: Colors.white70, decoration: TextDecoration.none),
    headline5: TextStyle(inherit: true, color: Color(0xe6ffffff), decoration: TextDecoration.none),
    headline6: TextStyle(inherit: true, color: Color(0xe6ffffff), decoration: TextDecoration.none),
    subtitle1: TextStyle(inherit: true, color: Color(0xe6ffffff), decoration: TextDecoration.none),
    bodyText1: TextStyle(inherit: true, color: Color(0xe6ffffff), decoration: TextDecoration.none),
    bodyText2: TextStyle(inherit: true, color: Color(0xe6ffffff), decoration: TextDecoration.none),
    caption: TextStyle(inherit: true, color: Colors.white70, decoration: TextDecoration.none),
    button: TextStyle(inherit: true, color: Color(0xe6ffffff), decoration: TextDecoration.none),
    subtitle2: TextStyle(inherit: true, color: Color(0xe6ffffff), decoration: TextDecoration.none),
    overline: TextStyle(inherit: true, color: Color(0xe6ffffff), decoration: TextDecoration.none),
  );
}
