import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemeData{
  static final ThemeData lightTheme = ThemeData(
    elevatedButtonTheme:ElevatedButtonThemeData(style:ButtonStyle(
      foregroundColor: WidgetStateProperty.all(Colors.black),
      backgroundColor:  WidgetStateProperty.all(Colors.yellowAccent),
    )),
    appBarTheme: AppBarTheme(titleTextStyle:GoogleFonts.abel(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color:Colors.white
    ), ),
    inputDecorationTheme:InputDecorationTheme(
      fillColor: Colors.red[200],
      border:OutlineInputBorder(
        borderSide:BorderSide(color: Colors.yellow), //black here
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),)
    ),

  );



  static final ThemeData darkTheme = ThemeData(
      elevatedButtonTheme:ElevatedButtonThemeData(style:ButtonStyle(
        foregroundColor: WidgetStateProperty.all(Colors.black),
        backgroundColor:  WidgetStateProperty.all(Colors.yellowAccent),
      )),
appBarTheme: AppBarTheme(titleTextStyle:GoogleFonts.manrope(
  fontSize: 20,
  fontWeight: FontWeight.w700,
), ),
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