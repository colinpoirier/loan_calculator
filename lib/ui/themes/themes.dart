import 'package:flutter/material.dart';

class CalcThemes {

  static _primaryTheme(List args) => ThemeData(
    brightness: args[3],
    primaryColor: args[2],
    accentColor: args[2],
    scaffoldBackgroundColor: args[0],
    canvasColor: args[0],
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: args[1],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
    ),
    toggleableActiveColor: args[4],
    textSelectionHandleColor: args[5],
    textTheme: args[6]
    
  );

  static ThemeData lightTheme = _primaryTheme([
    Colors.white,
    Colors.white,  
    Colors.blue[100],
    Brightness.light,
    Colors.black,
    Colors.blue,
    null
  ]);

  static ThemeData darkTheme = _primaryTheme([
    Colors.grey[850],
    Colors.grey[600],
    Color(0xFF002a62),
    Brightness.dark,
    Colors.grey[600],
    Colors.blue[100],
    whiteTextTheme,
  ]);
  static const TextTheme whiteTextTheme = TextTheme(
    display4   : TextStyle(inherit: true, color: Colors.white70, decoration: TextDecoration.none),
    display3   : TextStyle(inherit: true, color: Colors.white70, decoration: TextDecoration.none),
    display2   : TextStyle(inherit: true, color: Colors.white70, decoration: TextDecoration.none),
    display1   : TextStyle(inherit: true, color: Colors.white70, decoration: TextDecoration.none),
    headline   : TextStyle(inherit: true, color: Color(0xe6ffffff),   decoration: TextDecoration.none),
    title      : TextStyle(inherit: true, color:  Color(0xe6ffffff),   decoration: TextDecoration.none),
    subhead    : TextStyle(inherit: true, color: Color(0xe6ffffff),   decoration: TextDecoration.none),
    body2      : TextStyle(inherit: true, color: Color(0xe6ffffff),   decoration: TextDecoration.none),
    body1      : TextStyle(inherit: true, color: Color(0xe6ffffff),   decoration: TextDecoration.none),
    caption    : TextStyle(inherit: true, color: Colors.white70, decoration: TextDecoration.none),
    button     : TextStyle(inherit: true, color: Color(0xe6ffffff),   decoration: TextDecoration.none),
    subtitle   : TextStyle(inherit: true, color: Color(0xe6ffffff),   decoration: TextDecoration.none),
    overline   : TextStyle(inherit: true, color: Color(0xe6ffffff),   decoration: TextDecoration.none),
  );
}
