import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AuthenticateProvider extends ChangeNotifier {
  var box = Hive.box('auth');
  bool isAuth = true;

  AuthProvider(){
    loadAuthData();
  }

  void authChange() {
    isAuth = !isAuth;
    saveAuthData();
    notifyListeners();
  }
  void saveAuthData() {
    box.put('auth', isAuth);
    notifyListeners();
  }
  void loadAuthData() {
    isAuth= box.get('auth', defaultValue: true);
    notifyListeners();
  }


}