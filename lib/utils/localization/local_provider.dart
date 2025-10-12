import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;
  var box = Hive.box('lg');
  Locale? get locale => _locale;
  LocaleProvider(){
    _loadLocale();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    box.put('lg',locale.languageCode);
    notifyListeners();
  }

  void clearLocale() {
    _locale = null;
    notifyListeners();
  }
  void _loadLocale() {
    final code=box.get('lg',defaultValue: 'en');
    _locale = Locale(code);
    notifyListeners();
  }
}
