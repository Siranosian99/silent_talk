import 'package:flutter/material.dart';

class AppThemeData{
  static final ThemeData lightTheme = ThemeData(
    elevatedButtonTheme:ElevatedButtonThemeData(style:ButtonStyle(
      foregroundColor: WidgetStateProperty.all(Colors.black),
      backgroundColor:  WidgetStateProperty.all(Colors.yellowAccent),
    )),
    inputDecorationTheme:InputDecorationTheme(
      fillColor: Colors.red[200],
      border:OutlineInputBorder(
        borderSide:BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),)
    ),

  );



  static final ThemeData darkTheme = ThemeData(
      elevatedButtonTheme:ElevatedButtonThemeData(style:ButtonStyle(
        foregroundColor: WidgetStateProperty.all(Colors.black),
        backgroundColor:  WidgetStateProperty.all(Colors.yellowAccent),
      )),
      inputDecorationTheme:InputDecorationTheme(
          fillColor: Colors.red[200],
          border:OutlineInputBorder(
            borderSide:BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          )
      )
  );
}