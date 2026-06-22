import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static final lightThemeCard = BoxDecoration(
    color: Colors.indigo,
    borderRadius: BorderRadius.circular(30.0),
    border: Border.all(color: Colors.black, width: 2.0),
    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5.0)],
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: Colors.white,
    elevatedButtonTheme:ElevatedButtonThemeData(
      style:ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(220, 255, 0, 0.8),
        foregroundColor: Colors.blue ,
        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ), // button color
      )
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.deepPurple,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade800,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    elevatedButtonTheme:ElevatedButtonThemeData(
        style:ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(169, 14, 218, 0.8),
          foregroundColor: Colors.white ,
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ), // button color
        )
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white70),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  );
  static final darkThemeCard = BoxDecoration(
    color: Colors.deepPurple,
    borderRadius: BorderRadius.circular(30.0),
    border: Border.all(color: Colors.black, width: 2.0),
    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5.0)],
  );

}
