import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  var box = Hive.box('themes');
  bool isDark = false;

  ThemeProvider(){
    loadThemeMode();
  }

  void themeSwitch() {
    isDark = !isDark;
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    saveThemeData();
    notifyListeners();
  }
  void saveThemeData() {
    box.put('isDarkMode', isDark);
    notifyListeners();
  }
  void loadThemeMode() {
    isDark= box.get('isDarkMode', defaultValue: false);
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }


}